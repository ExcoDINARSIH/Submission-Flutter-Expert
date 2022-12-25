part of 'movies_bloc.dart';

@immutable

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object> get props => [];
}

class NowPlaying extends MoviesEvent {}

class Popular extends MoviesEvent {}

class TopRated extends MoviesEvent {}

class Detail extends MoviesEvent {
  final int id;

  const Detail(this.id);

  @override
  List<Object> get props => [id];
}

class Recommendations extends MoviesEvent {
  final int id;

  const Recommendations(this.id);

  @override
  List<Object> get props => [id];
}

abstract class SearchMoviesEvent extends Equatable {
  const SearchMoviesEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends SearchMoviesEvent {
  final String query;

  OnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}


abstract class WatchlistEvent extends Equatable {}

class Watchlist extends WatchlistEvent {
  @override
  List<Object?> get props => [];
}

class WatchlistStatus extends WatchlistEvent {
  final int id;

  WatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class WatchlistSave extends WatchlistEvent {
  final MovieDetail detail;

 WatchlistSave(this.detail);

  @override
  List<Object?> get props => [detail];
}

class WatchlistRemove extends WatchlistEvent {
  final MovieDetail detail;

  WatchlistRemove(this.detail);

  @override
  List<Object?> get props => [detail];
}
