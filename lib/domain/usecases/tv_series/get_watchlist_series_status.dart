import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class GetWatchListSeriesStatus {
  final TVSeriesRepository repository;

  GetWatchListSeriesStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
