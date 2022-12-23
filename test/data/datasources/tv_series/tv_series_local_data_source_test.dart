import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series/tv_series_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_series/dummy_objects_tv_series.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late TVSeriesLocalDataSourceImpl dataSource;
  late MockDatabaseHelperSeries mockDatabaseHelperSeries;

  setUp(() {
    mockDatabaseHelperSeries = MockDatabaseHelperSeries();
    dataSource = TVSeriesLocalDataSourceImpl(databaseHelperSeries: mockDatabaseHelperSeries);
  });

  group('save watchlist', () {
    test('should return success message when insert to database is success',
            () async {
          // arrange
          when(mockDatabaseHelperSeries.insertWatchlistSeries(testTVSeriesTable))
              .thenAnswer((_) async => 1);
          // act
          final result = await dataSource.insertWatchlistSeries(testTVSeriesTable);
          // assert
          expect(result, 'Added to Watchlist');
        });

    test('should throw DatabaseException when insert to database is failed',
            () async {
          // arrange
          when(mockDatabaseHelperSeries.insertWatchlistSeries(testTVSeriesTable))
              .thenThrow(Exception());
          // act
          final call = dataSource.insertWatchlistSeries(testTVSeriesTable);
          // assert
          expect(() => call, throwsA(isA<DatabaseException>()));
        });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is success',
            () async {
          // arrange
          when(mockDatabaseHelperSeries.removeWatchlistSeries(testTVSeriesTable))
              .thenAnswer((_) async => 1);
          // act
          final result = await dataSource.removeWatchlistSeries(testTVSeriesTable);
          // assert
          expect(result, 'Removed from Watchlist');
        });

    test('should throw DatabaseException when remove from database is failed',
            () async {
          // arrange
          when(mockDatabaseHelperSeries.removeWatchlistSeries(testTVSeriesTable))
              .thenThrow(Exception());
          // act
          final call = dataSource.removeWatchlistSeries(testTVSeriesTable);
          // assert
          expect(() => call, throwsA(isA<DatabaseException>()));
        });
  });

  group('Get TV Series Detail By Id', () {
    final tId = 1;

    test('should return TV Series Detail Table when data is found', () async {
      // arrange
      when(mockDatabaseHelperSeries.getSeriesById(tId))
          .thenAnswer((_) async => testTVSeriesMap);
      // act
      final result = await dataSource.getSeriesById(tId);
      // assert
      expect(result, testTVSeriesTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelperSeries.getSeriesById(tId)).thenAnswer((_) async => null);
      // act
      final result = await dataSource.getSeriesById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist series', () {
    test('should return list of TVSeriesTable from database', () async {
      // arrange
      when(mockDatabaseHelperSeries.getWatchlistSeries())
          .thenAnswer((_) async => [testTVSeriesMap]);
      // act
      final result = await dataSource.getWatchlistSeries();
      // assert
      expect(result, [testTVSeriesTable]);
    });
  });

  group('cache now playing series', () {
    test('should call database helper to save data', () async {
      // arrange
      when(mockDatabaseHelperSeries.clearCacheSeries('now playing'))
          .thenAnswer((_) async => 1);
      // act
      await dataSource.cacheNowPlayingSeries([testTVSeriesCache]);
      // assert
      verify(mockDatabaseHelperSeries.clearCacheSeries('now playing'));
      verify(mockDatabaseHelperSeries
          .insertCacheTransactionSeries([testTVSeriesCache], 'now playing'));
    });

    test('should return list of series from db when data exist', () async {
      // arrange
      when(mockDatabaseHelperSeries.getCacheSeries('now playing'))
          .thenAnswer((_) async => [testTVSeriesCacheMap]);
      // act
      final result = await dataSource.getCachedNowPlayingSeries();
      // assert
      expect(result, [testTVSeriesCache]);
    });

    test('should throw CacheException when cache data is not exist', () async {
      // arrange
      when(mockDatabaseHelperSeries.getCacheSeries('now playing'))
          .thenAnswer((_) async => []);
      // act
      final call = dataSource.getCachedNowPlayingSeries();
      // assert
      expect(() => call, throwsA(isA<CacheException>()));
    });
  });
}
