import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:ditonton/data/models/tv_series/tv_series_table.dart';

class DatabaseHelperSeries {
  static DatabaseHelperSeries? _databaseHelperSeries;

  DatabaseHelperSeries._instance() {
    _databaseHelperSeries = this;
  }

  factory DatabaseHelperSeries() =>
      _databaseHelperSeries ?? DatabaseHelperSeries._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initializeDb();
    return _database;
  }

  static const String _tblWatchlist = 'watchlist';
  static const String _tblCache = 'cache';

  Future<Database> _initializeDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton-series.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblWatchlist (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE  $_tblCache (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT,
        category TEXT
      );
    ''');
  }

  Future<void> insertCacheTransactionSeries(
      List<TVSeriesTable> series, String category) async {
    final db = await database;
    db!.transaction((txn) async {
      for (final tv in series) {
        final tvJson = tv.toJson();
        tvJson['category'] = category;
        txn.insert(_tblCache, tvJson);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCacheSeries(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblCache,
      where: 'category = ?',
      whereArgs: [category],
    );

    return results;
  }

  Future<int> clearCacheSeries(String category) async {
    final db = await database;
    return await db!.delete(
      _tblCache,
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  Future<int> insertWatchlistSeries(TVSeriesTable series) async {
    final db = await database;
    return await db!.insert(_tblWatchlist, series.toJson());
  }

  Future<int> removeWatchlistSeries(TVSeriesTable series) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [series.id],
    );
  }

  Future<Map<String, dynamic>?> getSeriesById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistSeries() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblWatchlist);

    return results;
  }
}
