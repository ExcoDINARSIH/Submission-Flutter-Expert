import 'package:bloc_test/bloc_test.dart';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movies/movie.dart';
import 'package:ditonton/domain/usecases/movies/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movies/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movies/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movies/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/movies/save_watchlist.dart';
import 'package:ditonton/domain/usecases/movies/search_movies.dart';
import 'package:ditonton/presentation/bloc/movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../test/dummy_data/dummy_objects.dart';
import 'movies_bloc_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchlistMovies,
  GetWatchListStatus,
  RemoveWatchlist,
  SaveWatchlist,
  SearchMovies,
])
void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late NowPlayingBloc nowPlaying;
  late MockGetPopularMovies mockGetPopular;
  late PopularBloc popularBloc;
  late MockGetTopRatedMovies mockGetTopRated;
  late TopRatedBloc topRatedBloc;
  late DetailBloc detailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late WatchlistBloc movieWatchlistBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late RecommendationsBloc recommendationsBloc;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    nowPlaying = NowPlayingBloc(mockGetNowPlayingMovies);
    mockGetPopular = MockGetPopularMovies();
    popularBloc = PopularBloc(mockGetPopular);
    mockGetTopRated = MockGetTopRatedMovies();
    topRatedBloc = TopRatedBloc(mockGetTopRated);
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    recommendationsBloc = RecommendationsBloc(mockGetMovieRecommendations);
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    detailBloc = DetailBloc(mockGetMovieDetail);
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    movieWatchlistBloc = WatchlistBloc(
      mockGetWatchlistMovies,
      mockGetWatchListStatus,
      mockRemoveWatchlist,
      mockSaveWatchlist,
    );
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tMovieList = <Movie>[tMovie];

  final tId = 1;

  group('Now Playing Movies', () {
    test('initial state must be empty', () {
      expect(nowPlaying.state, MoviesLoading());
    });

    blocTest(
      'should emit[loading, movieHasData] when data is gotten succesfully',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return nowPlaying;
      },
      act: (NowPlayingBloc bloc) => bloc.add(NowPlaying()),
      wait: Duration(milliseconds: 500),
      expect: () => [MoviesLoading(), MoviesHasData(tMovieList)],
    );

    blocTest(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetNowPlayingMovies.execute()).thenAnswer(
            (realInvocation) async => Left(ServerFailure('Server Failure')));
        return nowPlaying;
      },
      act: (NowPlayingBloc bloc) => bloc.add(NowPlaying()),
      wait: Duration(milliseconds: 500),
      expect: () => [
        MoviesLoading(),
        MoviesError('Server Failure'),
      ],
      verify: (NowPlayingBloc bloc) =>
          verify(mockGetNowPlayingMovies.execute()),
    );
  });

  group('Popular Movies', () {
    test('initial state must be empty', () {
      expect(popularBloc.state, MoviesLoading());
    });

    blocTest(
      'should emit[loading, moviesHasData] when data is gotten succesfully',
      build: () {
        when(mockGetPopular.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return popularBloc;
      },
      act: (PopularBloc bloc) => bloc.add(Popular()),
      wait: Duration(milliseconds: 500),
      expect: () => [MoviesLoading(), MoviesHasData(tMovieList)],
    );

    blocTest(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetPopular.execute()).thenAnswer(
            (realInvocation) async => Left(ServerFailure('Server Failure')));
        return popularBloc;
      },
      act: (PopularBloc bloc) => bloc.add(Popular()),
      wait: Duration(milliseconds: 500),
      expect: () => [
        MoviesLoading(),
        const MoviesError('Server Failure'),
      ],
      verify: (bloc) => verify(mockGetPopular.execute()),
    );
  });

  group('Top Rated Movies', () {
    test('initial state must be empty', () {
      expect(topRatedBloc.state, MoviesLoading());
    });

    blocTest(
      'should emit[loading, tvSeriesHasData] when data is gotten succesfully',
      build: () {
        when(mockGetTopRated.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return topRatedBloc;
      },
      act: (TopRatedBloc bloc) => bloc.add(TopRated()),
      wait: const Duration(milliseconds: 500),
      expect: () => [MoviesLoading(), MoviesHasData(tMovieList)],
    );

    blocTest(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetTopRated.execute()).thenAnswer(
            (realInvocation) async => Left(ServerFailure('Server Failure')));
        return topRatedBloc;
      },
      act: (TopRatedBloc bloc) => bloc.add(TopRated()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MoviesLoading(),
        const MoviesError('Server Failure'),
      ],
      verify: (bloc) => verify(mockGetTopRated.execute()),
    );
  });

  group('Recommendation Movies', () {
    test('initial state must be empty', () {
      expect(recommendationsBloc.state, MoviesEmpty());
    });

    blocTest(
      'should emit[loading, movieHasData] when data is gotten succesfully',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovieList));
        return recommendationsBloc;
      },
      act: (RecommendationsBloc bloc) => bloc.add(Recommendations(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [MoviesLoading(), MoviesHasData(tMovieList)],
    );

    blocTest(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetMovieRecommendations.execute(tId)).thenAnswer(
            (realInvocation) async => Left(ServerFailure('Server Failure')));
        return recommendationsBloc;
      },
      act: (RecommendationsBloc bloc) => bloc.add(Recommendations(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MoviesLoading(),
        const MoviesError('Server Failure'),
      ],
      verify: (bloc) => verify(mockGetMovieRecommendations.execute(tId)),
    );
  });

  group('Details Movies', () {
    test('initial state must be empty', () {
      expect(detailBloc.state, MoviesLoading());
    });

    blocTest(
      'should emit[loading, moviesHasData] when data is gotten succesfully',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        return detailBloc;
      },
      act: (DetailBloc bloc) => bloc.add(Detail(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [MoviesLoading(), MoviesDetailHasData(testMovieDetail)],
    );

    blocTest(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetMovieDetail.execute(tId)).thenAnswer(
            (realInvocation) async => Left(ServerFailure('Server Failure')));
        return detailBloc;
      },
      act: (DetailBloc bloc) => bloc.add(Detail(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MoviesLoading(),
        const MoviesError('Server Failure'),
      ],
      verify: (bloc) => verify(mockGetMovieDetail.execute(tId)),
    );
  });

  group('Watchlist Movies', () {
    test('initial state must be empty', () {
      expect(movieWatchlistBloc.state, WatchlistEmpty());
    });

    group('Watchlist Movies', () {
      blocTest(
        'Should emit [Loading, HasData] when data is gotten successfully',
        build: () {
          when(mockGetWatchlistMovies.execute())
              .thenAnswer((_) async => Right(tMovieList));
          return movieWatchlistBloc;
        },
        act: (WatchlistBloc bloc) => bloc.add(Watchlist()),
        wait: const Duration(milliseconds: 500),
        expect: () => [
          WatchlistLoading(),
          WatchlistHasData(tMovieList),
        ],
        verify: (bloc) => verify(mockGetWatchlistMovies.execute()),
      );

      blocTest(
        'Should emit [Loading, Error] when get search is unsuccessful',
        build: () {
          when(mockGetWatchlistMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return movieWatchlistBloc;
        },
        act: (WatchlistBloc bloc) => bloc.add(Watchlist()),
        wait: const Duration(milliseconds: 500),
        expect: () => [
          WatchlistLoading(),
          WatchlistError('Server Failure'),
        ],
        verify: (bloc) => verify(mockGetWatchlistMovies.execute()),
      );
    });

    group('Watchlist Movies Status', () {
      blocTest(
        'Should emit [Loading, HasData] when data is gotten successfully',
        build: () {
          when(mockGetWatchListStatus.execute(tId))
              .thenAnswer((_) async => true);
          return movieWatchlistBloc;
        },
        act: (WatchlistBloc bloc) => bloc.add(WatchlistStatus(tId)),
        wait: const Duration(milliseconds: 500),
        expect: () => [
          WatchlistLoading(),
          WatchlistMoviesStatus(true),
        ],
        verify: (bloc) => verify(mockGetWatchListStatus.execute(tId)),
      );

      blocTest(
        'Should emit [Loading, Error] when get search is unsuccessful',
        build: () {
          when(mockGetWatchListStatus.execute(tId))
              .thenAnswer((_) async => false);
          return movieWatchlistBloc;
        },
        act: (WatchlistBloc bloc) => bloc.add(WatchlistStatus(tId)),
        wait: Duration(milliseconds: 500),
        expect: () => [
          WatchlistLoading(),
          WatchlistMoviesStatus(false),
        ],
        verify: (bloc) => verify(mockGetWatchListStatus.execute(tId)),
      );
    });

    group('Save Watchlist Movies', () {
      blocTest(
        'Should emit [Loading, HasData] when data is gotten successfully',
        build: () {
          when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer(
              (_) async => Right(WatchlistBloc.watchlistAddSuccessMessage));
          return movieWatchlistBloc;
        },
        act: (WatchlistBloc bloc) => bloc.add(WatchlistSave(testMovieDetail)),
        wait: Duration(milliseconds: 500),
        expect: () => [
          WatchlistLoading(),
          WatchlistMessage(WatchlistBloc.watchlistAddSuccessMessage),
        ],
        verify: (bloc) => verify(mockSaveWatchlist.execute(testMovieDetail)),
      );

      blocTest(
        'Should emit [Loading, Error] when get search is unsuccessful',
        build: () {
          when(mockSaveWatchlist.execute(testMovieDetail))
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return movieWatchlistBloc;
        },
        act: (WatchlistBloc bloc) => bloc.add(WatchlistSave(testMovieDetail)),
        wait: Duration(milliseconds: 500),
        expect: () => [
          WatchlistLoading(),
          WatchlistError('Server Failure'),
        ],
        verify: (bloc) => verify(mockSaveWatchlist.execute(testMovieDetail)),
      );
    });

    group('Remove Watchlist Movies', () {
      blocTest(
        'Should emit [Loading, HasData] when data is gotten successfully',
        build: () {
          when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer(
              (_) async => Right(WatchlistBloc.watchlistAddSuccessMessage));
          return movieWatchlistBloc;
        },
        act: (WatchlistBloc bloc) => bloc.add(WatchlistRemove(testMovieDetail)),
        wait: Duration(milliseconds: 500),
        expect: () => [
          WatchlistLoading(),
          WatchlistMessage(WatchlistBloc.watchlistAddSuccessMessage),
        ],
        verify: (bloc) => verify(mockRemoveWatchlist.execute(testMovieDetail)),
      );

      blocTest(
        'Should emit [Loading, Error] when get search is unsuccessful',
        build: () {
          when(mockRemoveWatchlist.execute(testMovieDetail))
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return movieWatchlistBloc;
        },
        act: (WatchlistBloc bloc) => bloc.add(WatchlistRemove(testMovieDetail)),
        wait: Duration(milliseconds: 500),
        expect: () => [
          WatchlistLoading(),
          WatchlistError('Server Failure'),
        ],
        verify: (bloc) => verify(mockRemoveWatchlist.execute(testMovieDetail)),
      );
    });
  });
}
