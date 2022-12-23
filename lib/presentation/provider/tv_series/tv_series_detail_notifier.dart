import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_recommendations.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_series_status.dart';
import 'package:ditonton/domain/usecases/tv_series/remove_watchlist_series.dart';
import 'package:ditonton/domain/usecases/tv_series/save_watchlist_series.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TVSeriesDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTVSeriesDetail getTVSeriesDetail;
  final GetTVSeriesRecommendations getTVSeriesRecommendations;
  final GetWatchListSeriesStatus getWatchListSeriesStatus;
  final SaveWatchlistSeries saveWatchlistSeries;
  final RemoveWatchlistSeries removeWatchlistSeries;

  TVSeriesDetailNotifier({
    required this.getTVSeriesDetail,
    required this.getTVSeriesRecommendations,
    required this.getWatchListSeriesStatus,
    required this.saveWatchlistSeries,
    required this.removeWatchlistSeries,
  });

  late TVSeriesDetail _series;
  TVSeriesDetail get series => _series;

  RequestState _seriesState = RequestState.Empty;
  RequestState get seriesState => _seriesState;

  List<TVSeries> _seriesRecommendations = [];
  List<TVSeries> get seriesRecommendations => _seriesRecommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  Future<void> fetchTVSeriesDetail(int id) async {
    _seriesState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTVSeriesDetail.execute(id);
    final recommendationResult = await getTVSeriesRecommendations.execute(id);
    detailResult.fold(
          (failure) {
        _seriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (series) {
        _recommendationState = RequestState.Loading;
        _series = series;
        notifyListeners();
        recommendationResult.fold(
              (failure) {
            _recommendationState = RequestState.Error;
            _message = failure.message;
          },
              (series) {
            _recommendationState = RequestState.Loaded;
            _seriesRecommendations = series;
          },
        );
        _seriesState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlistSeries(TVSeriesDetail series) async {
    final result = await saveWatchlistSeries.execute(series);

    await result.fold(
          (failure) async {
        _watchlistMessage = failure.message;
      },
          (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatusSeries(series.id);
  }

  Future<void> removeFromWatchlistSeries(TVSeriesDetail series) async {
    final result = await removeWatchlistSeries.execute(series);

    await result.fold(
          (failure) async {
        _watchlistMessage = failure.message;
      },
          (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatusSeries(series.id);
  }

  Future<void> loadWatchlistStatusSeries(int id) async {
    final result = await getWatchListSeriesStatus.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
