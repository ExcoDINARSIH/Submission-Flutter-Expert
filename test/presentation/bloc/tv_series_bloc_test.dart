import 'package:bloc_test/bloc_test.dart';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_series_status.dart';
import 'package:ditonton/domain/usecases/tv_series/remove_watchlist_series.dart';
import 'package:ditonton/domain/usecases/tv_series/save_watchlist_series.dart';
import 'package:ditonton/domain/usecases/tv_series/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../test/dummy_data/tv_series/dummy_objects_tv_series.dart';

import 'tv_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingTVSeries,
  GetPopularTVSeries,
  GetTopRatedTVSeries,
  GetTVSeriesDetail,
  GetTVSeriesRecommendations,
  GetWatchlistTVSeries,
  GetWatchListSeriesStatus,
  RemoveWatchlistSeries,
  SaveWatchlistSeries,
  SearchTVSeries,
])
void main() {
  late MockGetNowPlayingTVSeries mockGetNowPlayingTVSeries;
  late NowPlayingTVSeriesBloc nowPlayingTVSeriesBloc;
  late MockGetPopularTVSeries mockGetPopularTVSeries;
  late PopularTVSeriesBloc popularTVSeriesBloc;
  late MockGetTopRatedTVSeries mockGetTopRatedTVSeries;
  late TopRatedTVSeriesBloc topRatedTVSeriesBloc;
  late TVSeriesDetailBloc seriesDetailBloc;
  late MockGetTVSeriesDetail mockGetTVSeriesDetail;
  late MockGetTVSeriesRecommendations mockGetTVSeriesRecommendations;
  late MockGetWatchListSeriesStatus mockGetWatchListSeriesStatus;
  late MockSaveWatchlistSeries mockSaveWatchlistSeries;
  late MockRemoveWatchlistSeries mockRemoveWatchlistSeries;
  late TVSeriesWatchlistBloc seriesWatchlistBloc;
  late MockGetWatchlistTVSeries mockGetWatchlistTVSeries;
  late TVSeriesRecommendationsBloc seriesRecommendationsBloc;

  setUp(() {
    mockGetNowPlayingTVSeries = MockGetNowPlayingTVSeries();
    nowPlayingTVSeriesBloc = NowPlayingTVSeriesBloc(mockGetNowPlayingTVSeries);
    mockGetPopularTVSeries = MockGetPopularTVSeries();
    popularTVSeriesBloc = PopularTVSeriesBloc(mockGetPopularTVSeries);
    mockGetTopRatedTVSeries = MockGetTopRatedTVSeries();
    topRatedTVSeriesBloc = TopRatedTVSeriesBloc(mockGetTopRatedTVSeries);
    mockGetTVSeriesDetail = MockGetTVSeriesDetail();
    mockGetTVSeriesRecommendations = MockGetTVSeriesRecommendations();
    seriesRecommendationsBloc =
        TVSeriesRecommendationsBloc(mockGetTVSeriesRecommendations);
    mockGetWatchListSeriesStatus = MockGetWatchListSeriesStatus();
    mockSaveWatchlistSeries = MockSaveWatchlistSeries();
    mockRemoveWatchlistSeries = MockRemoveWatchlistSeries();
    seriesDetailBloc = TVSeriesDetailBloc(mockGetTVSeriesDetail);
    mockGetWatchlistTVSeries = MockGetWatchlistTVSeries();
    seriesWatchlistBloc = TVSeriesWatchlistBloc(
      mockGetWatchlistTVSeries,
      mockGetWatchListSeriesStatus,
      mockRemoveWatchlistSeries,
      mockSaveWatchlistSeries,
    );
  });

  final tSeries = TVSeries(
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

  final tTVSeriesList = <TVSeries>[tSeries];
  final tId = 1;

  group('Now Playing series', () {
    test('initialState must be empty', () {
      expect(nowPlayingTVSeriesBloc.state, TVSeriesLoading());
    });

    blocTest(
      'should emit[loading, tvSeriesHasData] when data is gotten succesfully',
      build: () {
        when(mockGetNowPlayingTVSeries.execute())
            .thenAnswer((_) async => Right(tTVSeriesList));
        return nowPlayingTVSeriesBloc;
      },
      act: (NowPlayingTVSeriesBloc bloc) => bloc.add(NowPlayingTVSeries()),
      wait: Duration(milliseconds: 500),
      expect: () => [TVSeriesLoading(), TVSeriesHasData(tTVSeriesList)],
    );

    blocTest(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetNowPlayingTVSeries.execute()).thenAnswer(
            (realInvocation) async => Left(ServerFailure('Server Failure')));
        return nowPlayingTVSeriesBloc;
      },
      act: (NowPlayingTVSeriesBloc bloc) => bloc.add(NowPlayingTVSeries()),
      wait: Duration(milliseconds: 500),
      expect: () => [
        TVSeriesLoading(),
        TVSeriesError('Server Failure'),
      ],
      verify: (NowPlayingTVSeriesBloc bloc) =>
          verify(mockGetNowPlayingTVSeries.execute()),
    );
  });

  group('Popular Series', () {
    test('initial state must be empty', () {
      expect(popularTVSeriesBloc.state, TVSeriesLoading());
    });

    blocTest(
      'should emit[loading, tvSeriesHasData] when data is gotten succesfully',
      build: () {
        when(mockGetPopularTVSeries.execute())
            .thenAnswer((_) async => Right(tTVSeriesList));
        return popularTVSeriesBloc;
      },
      act: (PopularTVSeriesBloc bloc) => bloc.add(PopularTVSeries()),
      wait: Duration(milliseconds: 500),
      expect: () => [TVSeriesLoading(), TVSeriesHasData(tTVSeriesList)],
    );

    blocTest(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetPopularTVSeries.execute()).thenAnswer(
            (realInvocation) async => Left(ServerFailure('Server Failure')));
        return popularTVSeriesBloc;
      },
      act: (PopularTVSeriesBloc bloc) => bloc.add(PopularTVSeries()),
      wait: Duration(milliseconds: 500),
      expect: () => [
        TVSeriesLoading(),
        const TVSeriesError('Server Failure'),
      ],
      verify: (bloc) => verify(mockGetPopularTVSeries.execute()),
    );
  });

  group('Top Rated TV Series', () {
    test('initial state must be empty', () {
      expect(topRatedTVSeriesBloc.state, TVSeriesLoading());
    });

    blocTest(
      'should emit[loading, tvSeriesHasData] when data is gotten succesfully',
      build: () {
        when(mockGetTopRatedTVSeries.execute())
            .thenAnswer((_) async => Right(tTVSeriesList));
        return topRatedTVSeriesBloc;
      },
      act: (TopRatedTVSeriesBloc bloc) => bloc.add(TopRatedTVSeries()),
      wait: const Duration(milliseconds: 500),
      expect: () => [TVSeriesLoading(), TVSeriesHasData(tTVSeriesList)],
    );

    blocTest(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetTopRatedTVSeries.execute()).thenAnswer(
            (realInvocation) async => Left(ServerFailure('Server Failure')));
        return topRatedTVSeriesBloc;
      },
      act: (TopRatedTVSeriesBloc bloc) => bloc.add(TopRatedTVSeries()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TVSeriesLoading(),
        const TVSeriesError('Server Failure'),
      ],
      verify: (bloc) => verify(mockGetTopRatedTVSeries.execute()),
    );
  });

  group('Recommendation TV Series', () {
    test('initial state must be empty', () {
      expect(seriesRecommendationsBloc.state, TVSeriesEmpty());
    });

    blocTest(
      'should emit[loading, movieHasData] when data is gotten succesfully',
      build: () {
        when(mockGetTVSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTVSeriesList));
        return seriesRecommendationsBloc;
      },
      act: (TVSeriesRecommendationsBloc bloc) =>
          bloc.add(TVSeriesRecommendations(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [TVSeriesLoading(), TVSeriesHasData(tTVSeriesList)],
    );

    blocTest(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetTVSeriesRecommendations.execute(tId)).thenAnswer(
            (realInvocation) async => Left(ServerFailure('Server Failure')));
        return seriesRecommendationsBloc;
      },
      act: (TVSeriesRecommendationsBloc bloc) =>
          bloc.add(TVSeriesRecommendations(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TVSeriesLoading(),
        const TVSeriesError('Server Failure'),
      ],
      verify: (bloc) => verify(mockGetTVSeriesRecommendations.execute(tId)),
    );
  });

  group('Details TV Series', () {
    test('initial state must be empty', () {
      expect(seriesDetailBloc.state, TVSeriesLoading());
    });

    blocTest(
      'should emit[loading, seriesHasData] when data is gotten succesfully',
      build: () {
        when(mockGetTVSeriesDetail.execute(tId))
            .thenAnswer((_) async => Right(testTVSeriesDetail));
        return seriesDetailBloc;
      },
      act: (TVSeriesDetailBloc bloc) => bloc.add(SeriesDetail(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () =>
          [TVSeriesLoading(), SeriesDetailHasData(testTVSeriesDetail)],
    );

    blocTest(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetTVSeriesDetail.execute(tId)).thenAnswer(
            (realInvocation) async => Left(ServerFailure('Server Failure')));
        return seriesDetailBloc;
      },
      act: (TVSeriesDetailBloc bloc) => bloc.add(SeriesDetail(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TVSeriesLoading(),
        const TVSeriesError('Server Failure'),
      ],
      verify: (bloc) => verify(mockGetTVSeriesDetail.execute(tId)),
    );
  });

  group('Watchlist TV Series', () {
    test('initial state must be empty', () {
      expect(seriesWatchlistBloc.state, WatchlistSeriesEmpty());
    });

    group('Watchlist Series', () {
      blocTest(
        'Should emit [Loading, HasData] when data is gotten successfully',
        build: () {
          when(mockGetWatchlistTVSeries.execute())
              .thenAnswer((_) async => Right(tTVSeriesList));
          return seriesWatchlistBloc;
        },
        act: (TVSeriesWatchlistBloc bloc) => bloc.add(TVSeriesWatchlist()),
        wait: const Duration(milliseconds: 500),
        expect: () => [
          WatchlistSeriesLoading(),
          WatchlistSeriesHasData(tTVSeriesList),
        ],
        verify: (bloc) => verify(mockGetWatchlistTVSeries.execute()),
      );

      blocTest(
        'Should emit [Loading, Error] when get search is unsuccessful',
        build: () {
          when(mockGetWatchlistTVSeries.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return seriesWatchlistBloc;
        },
        act: (TVSeriesWatchlistBloc bloc) => bloc.add(TVSeriesWatchlist()),
        wait: const Duration(milliseconds: 500),
        expect: () => [
          WatchlistSeriesLoading(),
          WatchlistSeriesError('Server Failure'),
        ],
        verify: (bloc) => verify(mockGetWatchlistTVSeries.execute()),
      );
    });

    group('Watchlist TV Series Status', () {
      blocTest(
        'Should emit [Loading, HasData] when data is gotten successfully',
        build: () {
          when(mockGetWatchListSeriesStatus.execute(tId))
              .thenAnswer((_) async => true);
          return seriesWatchlistBloc;
        },
        act: (TVSeriesWatchlistBloc bloc) =>
            bloc.add(TVSeriesWatchlistStatus(tId)),
        wait: const Duration(milliseconds: 500),
        expect: () => [
          WatchlistSeriesLoading(),
          WatchlistSeriesStatus(true),
        ],
        verify: (bloc) => verify(mockGetWatchListSeriesStatus.execute(tId)),
      );

      blocTest(
        'Should emit [Loading, Error] when get search is unsuccessful',
        build: () {
          when(mockGetWatchListSeriesStatus.execute(tId))
              .thenAnswer((_) async => false);
          return seriesWatchlistBloc;
        },
        act: (TVSeriesWatchlistBloc bloc) =>
            bloc.add(TVSeriesWatchlistStatus(tId)),
        wait: Duration(milliseconds: 500),
        expect: () => [
          WatchlistSeriesLoading(),
          WatchlistSeriesStatus(false),
        ],
        verify: (bloc) => verify(mockGetWatchListSeriesStatus.execute(tId)),
      );
    });

    group('Save Watchlist TV Series', () {
      blocTest(
        'Should emit [Loading, HasData] when data is gotten successfully',
        build: () {
          when(mockSaveWatchlistSeries.execute(testTVSeriesDetail)).thenAnswer(
              (_) async =>
                  Right(TVSeriesWatchlistBloc.watchlistAddSuccessMessage));
          return seriesWatchlistBloc;
        },
        act: (TVSeriesWatchlistBloc bloc) =>
            bloc.add(TVSeriesWatchlistSave(testTVSeriesDetail)),
        wait: Duration(milliseconds: 500),
        expect: () => [
          WatchlistSeriesLoading(),
          WatchlistSeriesMessage(
              TVSeriesWatchlistBloc.watchlistAddSuccessMessage),
        ],
        verify: (bloc) =>
            verify(mockSaveWatchlistSeries.execute(testTVSeriesDetail)),
      );

      blocTest(
        'Should emit [Loading, Error] when get search is unsuccessful',
        build: () {
          when(mockSaveWatchlistSeries.execute(testTVSeriesDetail))
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return seriesWatchlistBloc;
        },
        act: (TVSeriesWatchlistBloc bloc) =>
            bloc.add(TVSeriesWatchlistSave(testTVSeriesDetail)),
        wait: Duration(milliseconds: 500),
        expect: () => [
          WatchlistSeriesLoading(),
          WatchlistSeriesError('Server Failure'),
        ],
        verify: (bloc) =>
            verify(mockSaveWatchlistSeries.execute(testTVSeriesDetail)),
      );
    });

    group('Remove Watchlist TV Series', () {
      blocTest(
        'Should emit [Loading, HasData] when data is gotten successfully',
        build: () {
          when(mockRemoveWatchlistSeries.execute(testTVSeriesDetail))
              .thenAnswer((_) async =>
                  Right(TVSeriesWatchlistBloc.watchlistAddSuccessMessage));
          return seriesWatchlistBloc;
        },
        act: (TVSeriesWatchlistBloc bloc) =>
            bloc.add(TVSeriesWatchlistRemove(testTVSeriesDetail)),
        wait: Duration(milliseconds: 500),
        expect: () => [
          WatchlistSeriesLoading(),
          WatchlistSeriesMessage(
              TVSeriesWatchlistBloc.watchlistAddSuccessMessage),
        ],
        verify: (bloc) =>
            verify(mockRemoveWatchlistSeries.execute(testTVSeriesDetail)),
      );

      blocTest(
        'Should emit [Loading, Error] when get search is unsuccessful',
        build: () {
          when(mockRemoveWatchlistSeries.execute(testTVSeriesDetail))
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return seriesWatchlistBloc;
        },
        act: (TVSeriesWatchlistBloc bloc) =>
            bloc.add(TVSeriesWatchlistRemove(testTVSeriesDetail)),
        wait: Duration(milliseconds: 500),
        expect: () => [
          WatchlistSeriesLoading(),
          WatchlistSeriesError('Server Failure'),
        ],
        verify: (bloc) =>
            verify(mockRemoveWatchlistSeries.execute(testTVSeriesDetail)),
      );
    });
  });
}

