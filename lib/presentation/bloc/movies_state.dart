part of 'movies_bloc.dart';

@immutable
abstract class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object> get props => [];
}

class MoviesEmpty extends MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesHasData extends MoviesState {
  final List<Movie> result;

  const MoviesHasData(this.result);

  @override
  List<Object> get props => [result];
}

class MoviesError extends MoviesState {
  final String message;

  const MoviesError(this.message);

  @override
  List<Object> get props => [message];
}


class MoviesDetailHasData extends MoviesState {
  final MovieDetail detail;

  const MoviesDetailHasData(this.detail);

  @override
  List<Object> get props => [detail];
}

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchEmpty extends SearchState {}

class SearchLoading extends SearchState {}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchHasData extends SearchState {
  final List<Movie> result;

  SearchHasData(this.result);

  @override
  List<Object> get props => [result];
}

abstract class WatchlistState extends Equatable {}

class WatchlistMovies extends WatchlistState {
  @override
  List<Object?> get props => [];
}

class WatchlistMessage extends Watchlist {
  final String message;

  WatchlistMessage(this.message);
}

class WatchlistEmpty extends Watchlist {
  @override
  List<Object?> get props => [];
}

class WatchlistLoading extends Watchlist {
  @override
  List<Object?> get props => [];
}

class WatchlistHasData extends Watchlist {
  final List<Movie> result;

  WatchlistHasData(this.result);

  @override
  List<Object?> get props => [result];
}

class WatchlistError extends Watchlist {
  final String message;

  WatchlistError(this.message);

  @override
  List<Object?> get props => [message];
}

class WatchlistMoviesStatus extends Watchlist {
  final bool status;

  WatchlistMoviesStatus(this.status);
}
