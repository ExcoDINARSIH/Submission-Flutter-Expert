part of 'tv_series_bloc.dart';

@immutable
abstract class TVSeriesEvent extends Equatable {
  const TVSeriesEvent();

  @override
  List<Object> get props => [];
}

class NowPlayingTVSeries extends TVSeriesEvent {}

class PopularTVSeries extends TVSeriesEvent {}

class TopRatedTVSeries extends TVSeriesEvent {}

class SeriesDetail extends TVSeriesEvent {
  final int id;

  const SeriesDetail(this.id);

  @override
  List<Object> get props => [id];
}

class TVSeriesRecommendations extends TVSeriesEvent {
  final int id;

  const TVSeriesRecommendations(this.id);

  @override
  List<Object> get props => [id];
}

abstract class SearchSeriesEvent extends Equatable {
  const SearchSeriesEvent();

  @override
  List<Object> get props => [];
}

class OnSeriesQueryChanged extends SearchSeriesEvent {
  final String query;

  OnSeriesQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

abstract class TVSeriesWatchlistEvent extends Equatable {}

class TVSeriesWatchlist extends TVSeriesWatchlistEvent {
  @override
  List<Object?> get props => [];
}

class TVSeriesWatchlistStatus extends TVSeriesWatchlistEvent {
  final int id;

  TVSeriesWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class TVSeriesWatchlistSave extends TVSeriesWatchlistEvent {
  final TVSeriesDetail seriesDetail;

  TVSeriesWatchlistSave(this.seriesDetail);

  @override
  List<Object?> get props => [seriesDetail];
}

class TVSeriesWatchlistRemove extends TVSeriesWatchlistEvent {
  final TVSeriesDetail seriesDetail;

  TVSeriesWatchlistRemove(this.seriesDetail);

  @override
  List<Object?> get props => [seriesDetail];
}
