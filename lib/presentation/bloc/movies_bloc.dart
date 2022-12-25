import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/movies/search_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ditonton/domain/entities/movies/movie_detail.dart';
import 'package:ditonton/domain/entities/movies/movie.dart';
import 'package:ditonton/domain/usecases/movies/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movies/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movies/save_watchlist.dart';
import 'package:ditonton/domain/usecases/movies/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movies/remove_watchlist.dart';
import 'package:rxdart/rxdart.dart';

part 'movies_event.dart';

part 'movies_state.dart';

class NowPlayingBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetNowPlayingMovies getNowPlaying;

  NowPlayingBloc(this.getNowPlaying)
      : super(MoviesLoading()) {
    on<NowPlaying>((event, emit) async {
      emit(MoviesLoading());
      final result = await getNowPlaying.execute();
      result.fold((failure) {
        emit(MoviesError(failure.message));
      }, (data) => emit(MoviesHasData(data)));
    });
  }
}

class PopularBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetPopularMovies getPopular;

  PopularBloc(this.getPopular) : super(MoviesLoading()) {
    on<Popular>((event, emit) async {
      emit(MoviesLoading());
      final result = await getPopular.execute();
      result.fold((failure) {
        emit(MoviesError(failure.message));
      }, (data) => emit(MoviesHasData(data)));
    });
  }
}

class TopRatedBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetTopRatedMovies getTopRated;

  TopRatedBloc(this.getTopRated) : super(MoviesLoading()) {
    on<TopRated>((event, emit) async {
      emit(MoviesLoading());
      final result = await getTopRated.execute();
      result.fold((failure) {
        emit(MoviesError(failure.message));
      }, (data) => emit(MoviesHasData(data)));
    });
  }
}

class DetailBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetMovieDetail getDetail;

  DetailBloc(this.getDetail) : super(MoviesLoading()) {
    on<Detail>((event, emit) async {
      emit(MoviesLoading());
      final result = await getDetail.execute(event.id);
      result.fold((failure) {
        emit(MoviesError(failure.message));
      }, (data) => emit(MoviesDetailHasData(data)));
    });
  }
}

class RecommendationsBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetMovieRecommendations getRecommendations;

  RecommendationsBloc(this.getRecommendations)
      : super(MoviesEmpty()) {
    on<Recommendations>((event, emit) async {
      emit(MoviesLoading());
      final result = await getRecommendations.execute(event.id);
      result.fold((failure) {
        emit(MoviesError(failure.message));
      }, (data) => emit(MoviesHasData(data)));
    });
  }
}

class SearchBloc extends Bloc<SearchMoviesEvent, SearchState> {
  final SearchMovies _search;

  SearchBloc(this._search) : super(SearchEmpty()) {
    on<OnQueryChanged>(
          (event, emit) async {
        final query = event.query;

        emit(SearchLoading());
        final result = await _search.execute(query);

        result.fold(
              (failure) {
            emit(SearchError(failure.message));
          },
              (data) {
            emit(SearchHasData(data));
          },
        );
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }
  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}


class WatchlistBloc extends Bloc<WatchlistEvent, Watchlist> {
  final GetWatchlistMovies getWatchlist;
  final GetWatchListStatus getWatchlistStatus;
  final RemoveWatchlist removeWatchlist;
  final SaveWatchlist saveWatchlist;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  WatchlistBloc(this.getWatchlist, this.getWatchlistStatus,
      this.removeWatchlist, this.saveWatchlist)
      : super(WatchlistEmpty()) {
    on<WatchlistStatus>((event, emit) async {
      emit(WatchlistLoading());
      final result = await getWatchlistStatus.execute(event.id);
      emit(WatchlistMoviesStatus(result));
    });

    on<Watchlist>((event, emit) async {
      emit(WatchlistLoading());
      final result = await getWatchlist.execute();
      result.fold((failure) {
        emit(WatchlistError(failure.message));
      }, (data) {
        emit(WatchlistHasData(data));
      });
    });

    on<WatchlistSave>((event, emit) async {
      emit(WatchlistLoading());
      final result = await saveWatchlist.execute(event.detail);
      result.fold((failure) => emit(WatchlistError(failure.message)),
              (message) => emit(WatchlistMessage(message)));
    });

    on<WatchlistRemove>((event, emit) async {
      emit(WatchlistLoading());
      final result = await removeWatchlist.execute(event.detail);
      result.fold((failure) => emit(WatchlistError(failure.message)),
              (message) => emit(WatchlistMessage(message)));
    });
  }
}

