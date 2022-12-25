import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/tv_series/search_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series_detail.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/tv_series/save_watchlist_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/remove_watchlist_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_series_status.dart';
import 'package:rxdart/rxdart.dart';

part 'tv_series_event.dart';

part 'tv_series_state.dart';

class NowPlayingTVSeriesBloc extends Bloc<TVSeriesEvent, TVSeriesState> {
  final GetNowPlayingTVSeries getNowPlayingTVSeries;

  NowPlayingTVSeriesBloc(this.getNowPlayingTVSeries)
      : super(TVSeriesLoading()) {
    on<NowPlayingTVSeries>((event, emit) async {
      emit(TVSeriesLoading());
      final result = await getNowPlayingTVSeries.execute();
      result.fold((failure) {
        emit(TVSeriesError(failure.message));
      }, (seriesData) => emit(TVSeriesHasData(seriesData)));
    });
  }
}

class PopularTVSeriesBloc extends Bloc<TVSeriesEvent, TVSeriesState> {
  final GetPopularTVSeries getPopularTVSeries;

  PopularTVSeriesBloc(this.getPopularTVSeries) : super(TVSeriesLoading()) {
    on<PopularTVSeries>((event, emit) async {
      emit(TVSeriesLoading());
      final result = await getPopularTVSeries.execute();
      result.fold((failure) {
        emit(TVSeriesError(failure.message));
      }, (seriesData) => emit(TVSeriesHasData(seriesData)));
    });
  }
}

class TopRatedTVSeriesBloc extends Bloc<TVSeriesEvent, TVSeriesState> {
  final GetTopRatedTVSeries getTopRatedTVSeries;

  TopRatedTVSeriesBloc(this.getTopRatedTVSeries) : super(TVSeriesLoading()) {
    on<TopRatedTVSeries>((event, emit) async {
      emit(TVSeriesLoading());
      final result = await getTopRatedTVSeries.execute();
      result.fold((failure) {
        emit(TVSeriesError(failure.message));
      }, (seriesData) => emit(TVSeriesHasData(seriesData)));
    });
  }
}

class TVSeriesDetailBloc extends Bloc<TVSeriesEvent, TVSeriesState> {
  final GetTVSeriesDetail getTVSeriesDetail;

  TVSeriesDetailBloc(this.getTVSeriesDetail) : super(TVSeriesLoading()) {
    on<SeriesDetail>((event, emit) async {
      emit(TVSeriesLoading());
      final result = await getTVSeriesDetail.execute(event.id);
      result.fold((failure) {
        emit(TVSeriesError(failure.message));
      }, (seriesData) => emit(SeriesDetailHasData(seriesData)));
    });
  }
}

class TVSeriesRecommendationsBloc extends Bloc<TVSeriesEvent, TVSeriesState> {
  final GetTVSeriesRecommendations getTVSeriesRecommendations;

  TVSeriesRecommendationsBloc(this.getTVSeriesRecommendations)
      : super(TVSeriesEmpty()) {
    on<TVSeriesRecommendations>((event, emit) async {
      emit(TVSeriesLoading());
      final result = await getTVSeriesRecommendations.execute(event.id);
      result.fold((failure) {
        emit(TVSeriesError(failure.message));
      }, (seriesData) => emit(TVSeriesHasData(seriesData)));
    });
  }
}

class SearchSeriesBloc extends Bloc<SearchSeriesEvent, SearchSeriesState> {
  final SearchTVSeries _searchSeries;

  SearchSeriesBloc(this._searchSeries) : super(SearchSeriesEmpty()) {
    on<OnSeriesQueryChanged>(
          (event, emit) async {
        final query = event.query;

        emit(SearchSeriesLoading());
        final result = await _searchSeries.execute(query);

        result.fold(
              (failure) {
            emit(SearchSeriesError(failure.message));
          },
              (seriesData) {
            emit(SearchSeriesHasData(seriesData));
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


class TVSeriesWatchlistBloc
    extends Bloc<TVSeriesWatchlistEvent, WatchlistSeriesState> {
  final GetWatchlistTVSeries getWatchlistSeries;
  final GetWatchListSeriesStatus getWatchlistSeriesStatus;
  final RemoveWatchlistSeries removeWatchlistSeries;
  final SaveWatchlistSeries saveWatchlistSeries;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  TVSeriesWatchlistBloc(this.getWatchlistSeries, this.getWatchlistSeriesStatus,
      this.removeWatchlistSeries, this.saveWatchlistSeries)
      : super(WatchlistSeriesEmpty()) {
    on<TVSeriesWatchlistStatus>((event, emit) async {
      emit(WatchlistSeriesLoading());
      final result = await getWatchlistSeriesStatus.execute(event.id);
      emit(WatchlistSeriesStatus(result));
    });

    on<TVSeriesWatchlist>((event, emit) async {
      emit(WatchlistSeriesLoading());
      final result = await getWatchlistSeries.execute();
      result.fold((failure) {
        emit(WatchlistSeriesError(failure.message));
      }, (seriesData) {
        emit(WatchlistSeriesHasData(seriesData));
      });
    });

    on<TVSeriesWatchlistSave>((event, emit) async {
      emit(WatchlistSeriesLoading());
      final result = await saveWatchlistSeries.execute(event.seriesDetail);
      result.fold((failure) => emit(WatchlistSeriesError(failure.message)),
          (message) => emit(WatchlistSeriesMessage(message)));
    });

    on<TVSeriesWatchlistRemove>((event, emit) async {
      emit(WatchlistSeriesLoading());
      final result = await removeWatchlistSeries.execute(event.seriesDetail);
      result.fold((failure) => emit(WatchlistSeriesError(failure.message)),
          (message) => emit(WatchlistSeriesMessage(message)));
    });
  }
}
