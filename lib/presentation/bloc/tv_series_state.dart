part of 'tv_series_bloc.dart';

@immutable
abstract class TVSeriesState extends Equatable {
  const TVSeriesState();

  @override
  List<Object> get props => [];
}

class TVSeriesEmpty extends TVSeriesState {}

class TVSeriesLoading extends TVSeriesState {}

class TVSeriesHasData extends TVSeriesState {
  final List<TVSeries> result;

  const TVSeriesHasData(this.result);

  @override
  List<Object> get props => [result];
}

class TVSeriesError extends TVSeriesState {
  final String message;

  const TVSeriesError(this.message);

  @override
  List<Object> get props => [message];
}


class SeriesDetailHasData extends TVSeriesState {
  final TVSeriesDetail detailSeries;

  const SeriesDetailHasData(this.detailSeries);

  @override
  List<Object> get props => [detailSeries];
}

abstract class SearchSeriesState extends Equatable {
  const SearchSeriesState();

  @override
  List<Object> get props => [];
}

class SearchSeriesEmpty extends SearchSeriesState {}

class SearchSeriesLoading extends SearchSeriesState {}

class SearchSeriesError extends SearchSeriesState {
  final String message;

  SearchSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchSeriesHasData extends SearchSeriesState {
  final List<TVSeries> result;

  SearchSeriesHasData(this.result);

  @override
  List<Object> get props => [result];
}

abstract class WatchlistSeriesState extends Equatable {}

class WatchlistSeries extends WatchlistSeriesState {
  @override
  List<Object?> get props => [];
}

class WatchlistSeriesMessage extends WatchlistSeries {
  final String message;

  WatchlistSeriesMessage(this.message);
}

class WatchlistSeriesEmpty extends WatchlistSeries {
  @override
  List<Object?> get props => [];
}

class WatchlistSeriesLoading extends WatchlistSeries {
  @override
  List<Object?> get props => [];
}

class WatchlistSeriesHasData extends WatchlistSeries {
  final List<TVSeries> result;

  WatchlistSeriesHasData(this.result);

  @override
  List<Object?> get props => [result];
}

class WatchlistSeriesError extends WatchlistSeries {
  final String message;

  WatchlistSeriesError(this.message);

  @override
  List<Object?> get props => [message];
}

class WatchlistSeriesStatus extends WatchlistSeries {
  final bool status;

  WatchlistSeriesStatus(this.status);
}
