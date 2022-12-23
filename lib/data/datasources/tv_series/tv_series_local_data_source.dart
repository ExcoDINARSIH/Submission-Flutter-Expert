import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series/db/database_helper_tv_series.dart';
import 'package:ditonton/data/models/tv_series/tv_series_table.dart';

abstract class TVSeriesLocalDataSource {
  Future<String> insertWatchlistSeries(TVSeriesTable series);
  Future<String> removeWatchlistSeries(TVSeriesTable series);
  Future<TVSeriesTable?> getSeriesById(int id);
  Future<List<TVSeriesTable>> getWatchlistSeries();
  Future<void> cacheNowPlayingSeries(List<TVSeriesTable> series);
  Future<List<TVSeriesTable>> getCachedNowPlayingSeries();
}

class TVSeriesLocalDataSourceImpl implements TVSeriesLocalDataSource {
  final DatabaseHelperSeries databaseHelperSeries;

  TVSeriesLocalDataSourceImpl({required this.databaseHelperSeries});

  @override
  Future<String> insertWatchlistSeries(TVSeriesTable series) async {
    try {
      await databaseHelperSeries.insertWatchlistSeries(series);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlistSeries(TVSeriesTable series) async {
    try {
      await databaseHelperSeries.removeWatchlistSeries(series);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TVSeriesTable?> getSeriesById(int id) async {
    final result = await databaseHelperSeries.getSeriesById(id);
    if (result != null) {
      return TVSeriesTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TVSeriesTable>> getWatchlistSeries() async {
    final result = await databaseHelperSeries.getWatchlistSeries();
    return result.map((data) => TVSeriesTable.fromMap(data)).toList();
  }

  @override
  Future<void> cacheNowPlayingSeries(List<TVSeriesTable> series) async {
    await databaseHelperSeries.clearCacheSeries('now playing');
    await databaseHelperSeries.insertCacheTransactionSeries(series, 'now playing');
  }

  @override
  Future<List<TVSeriesTable>> getCachedNowPlayingSeries() async {
    final result = await databaseHelperSeries.getCacheSeries('now playing');
    if (result.length > 0) {
      return result.map((data) => TVSeriesTable.fromMap(data)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }
}
