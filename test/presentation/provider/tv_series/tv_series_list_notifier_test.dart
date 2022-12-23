import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series/tv_series_list_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_list_notifier_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingTVSeries,
  GetPopularTVSeries,
  GetTopRatedTVSeries,
])
void main() {
  late TVSeriesListNotifier provider;
  late MockGetNowPlayingTVSeries mockGetNowPlayingTVSeries;
  late MockGetPopularTVSeries mockGetPopularTVSeries;
  late MockGetTopRatedTVSeries mockGetTopRatedTVSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingTVSeries = MockGetNowPlayingTVSeries();
    mockGetPopularTVSeries = MockGetPopularTVSeries();
    mockGetTopRatedTVSeries = MockGetTopRatedTVSeries();
    provider = TVSeriesListNotifier(
      getNowPlayingTVSeries: mockGetNowPlayingTVSeries,
      getPopularTVSeries: mockGetPopularTVSeries,
      getTopRatedTVSeries: mockGetTopRatedTVSeries,
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

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

  final tTVSeriesList = <TVSeries>[tTV];

  group('now playing series', () {
    test('initialState should be Empty', () {
      expect(provider.nowPlayingState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetNowPlayingTVSeries.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      // act
      provider.fetchNowPlayingTVSeries();
      // assert
      verify(mockGetNowPlayingTVSeries.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetNowPlayingTVSeries.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      // act
      provider.fetchNowPlayingTVSeries();
      // assert
      expect(provider.nowPlayingState, RequestState.Loading);
    });

    test('should change series when data is gotten successfully', () async {
      // arrange
      when(mockGetNowPlayingTVSeries.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      // act
      await provider.fetchNowPlayingTVSeries();
      // assert
      expect(provider.nowPlayingState, RequestState.Loaded);
      expect(provider.nowPlayingTVSeries, tTVSeriesList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetNowPlayingTVSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchNowPlayingTVSeries();
      // assert
      expect(provider.nowPlayingState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular series', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularTVSeries.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      // act
      provider.fetchPopularTVSeries();
      // assert
      expect(provider.popularTVSeriesState, RequestState.Loading);
      // verify(provider.setState(RequestState.Loading));
    });

    test('should change series data when data is gotten successfully',
            () async {
          // arrange
          when(mockGetPopularTVSeries.execute())
              .thenAnswer((_) async => Right(tTVSeriesList));
          // act
          await provider.fetchPopularTVSeries();
          // assert
          expect(provider.popularTVSeriesState, RequestState.Loaded);
          expect(provider.popularTVSeries, tTVSeriesList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularTVSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularTVSeries();
      // assert
      expect(provider.popularTVSeriesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated series', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedTVSeries.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      // act
      provider.fetchTopRatedTVSeries();
      // assert
      expect(provider.topRatedTVSeriesState, RequestState.Loading);
    });

    test('should change series data when data is gotten successfully',
            () async {
          // arrange
          when(mockGetTopRatedTVSeries.execute())
              .thenAnswer((_) async => Right(tTVSeriesList));
          // act
          await provider.fetchTopRatedTVSeries();
          // assert
          expect(provider.topRatedTVSeriesState, RequestState.Loaded);
          expect(provider.topRatedTVSeries, tTVSeriesList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTVSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedTVSeries();
      // assert
      expect(provider.topRatedTVSeriesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
