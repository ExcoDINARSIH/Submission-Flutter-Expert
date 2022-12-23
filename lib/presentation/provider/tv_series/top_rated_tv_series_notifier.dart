import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:flutter/foundation.dart';

class TopRatedTVSeriesNotifier extends ChangeNotifier {
  final GetTopRatedTVSeries getTopRatedTVSeries;

  TopRatedTVSeriesNotifier({required this.getTopRatedTVSeries});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TVSeries> _series = [];
  List<TVSeries> get series => _series;

  String _message = '';
  String get message => _message;

  Future<void> fetchTopRatedTVSeries() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTVSeries.execute();

    result.fold(
          (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
          (seriesData) {
        _series = seriesData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
