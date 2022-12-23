import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_recommendations.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_series_status.dart';
import 'package:ditonton/domain/usecases/tv_series/remove_watchlist_series.dart';
import 'package:ditonton/domain/usecases/tv_series/save_watchlist_series.dart';
import 'package:ditonton/presentation/provider/tv_series/tv_series_detail_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_series/dummy_objects_tv_series.dart';
import 'tv_series_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTVSeriesDetail,
  GetTVSeriesRecommendations,
  GetWatchListSeriesStatus,
  SaveWatchlistSeries,
  RemoveWatchlistSeries,
])
void main() {
  late TVSeriesDetailNotifier provider;
  late MockGetTVSeriesDetail mockGetTVSeriesDetail;
  late MockGetTVSeriesRecommendations mockGetTVSeriesRecommendations;
  late MockGetWatchListSeriesStatus mockGetWatchlistSeriesStatus;
  late MockSaveWatchlistSeries mockSaveWatchlistSeries;
  late MockRemoveWatchlistSeries mockRemoveWatchlistSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTVSeriesDetail = MockGetTVSeriesDetail();
    mockGetTVSeriesRecommendations = MockGetTVSeriesRecommendations();
    mockGetWatchlistSeriesStatus = MockGetWatchListSeriesStatus();
    mockSaveWatchlistSeries = MockSaveWatchlistSeries();
    mockRemoveWatchlistSeries = MockRemoveWatchlistSeries();
    provider = TVSeriesDetailNotifier(
      getTVSeriesDetail: mockGetTVSeriesDetail,
      getTVSeriesRecommendations: mockGetTVSeriesRecommendations,
      getWatchListSeriesStatus: mockGetWatchlistSeriesStatus,
      saveWatchlistSeries: mockSaveWatchlistSeries,
      removeWatchlistSeries: mockRemoveWatchlistSeries,
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

  final tId = 1;

  final tTV = TVSeries(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTVSeries = <TVSeries>[tTV];

  void _arrangeUsecase() {
    when(mockGetTVSeriesDetail.execute(tId))
        .thenAnswer((_) async => Right(testTVSeriesDetail));
    when(mockGetTVSeriesRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tTVSeries));
  }

  group('Get TV Series Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTVSeriesDetail(tId);
      // assert
      verify(mockGetTVSeriesDetail.execute(tId));
      verify(mockGetTVSeriesRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchTVSeriesDetail(tId);
      // assert
      expect(provider.seriesState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change series when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTVSeriesDetail(tId);
      // assert
      expect(provider.seriesState, RequestState.Loaded);
      expect(provider.series, testTVSeriesDetail);
      expect(listenerCallCount, 3);
    });

    test('should change recommendation series when data is gotten successfully',
            () async {
          // arrange
          _arrangeUsecase();
          // act
          await provider.fetchTVSeriesDetail(tId);
          // assert
          expect(provider.seriesState, RequestState.Loaded);
          expect(provider.seriesRecommendations, tTVSeries);
        });
  });

  group('Get TV Series Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTVSeriesDetail(tId);
      // assert
      verify(mockGetTVSeriesRecommendations.execute(tId));
      expect(provider.seriesRecommendations, tTVSeries);
    });

    test('should update recommendation state when data is gotten successfully',
            () async {
          // arrange
          _arrangeUsecase();
          // act
          await provider.fetchTVSeriesDetail(tId);
          // assert
          expect(provider.recommendationState, RequestState.Loaded);
          expect(provider.seriesRecommendations, tTVSeries);
        });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetTVSeriesDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVSeriesDetail));
      when(mockGetTVSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchTVSeriesDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist TV Series', () {
    test('should get the watchlist series status', () async {
      // arrange
      when(mockGetWatchlistSeriesStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatusSeries(1);
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist series when function called', () async {
      // arrange
      when(mockSaveWatchlistSeries.execute(testTVSeriesDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistSeriesStatus.execute(testTVSeriesDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlistSeries(testTVSeriesDetail);
      // assert
      verify(mockSaveWatchlistSeries.execute(testTVSeriesDetail));
    });

    test('should execute remove watchlist series when function called', () async {
      // arrange
      when(mockRemoveWatchlistSeries.execute(testTVSeriesDetail))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistSeriesStatus.execute(testTVSeriesDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlistSeries(testTVSeriesDetail);
      // assert
      verify(mockRemoveWatchlistSeries.execute(testTVSeriesDetail));
    });

    test('should update watchlist series status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchlistSeries.execute(testTVSeriesDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistSeriesStatus.execute(testTVSeriesDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlistSeries(testTVSeriesDetail);
      // assert
      verify(mockGetWatchlistSeriesStatus.execute(testTVSeriesDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist series message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlistSeries.execute(testTVSeriesDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistSeriesStatus.execute(testTVSeriesDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.addWatchlistSeries(testTVSeriesDetail);
      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTVSeriesDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTVSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTVSeries));
      // act
      await provider.fetchTVSeriesDetail(tId);
      // assert
      expect(provider.seriesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}