import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series_detail.dart';
import 'package:ditonton/common/failure.dart';

abstract class TVSeriesRepository {
  Future<Either<Failure, List<TVSeries>>> getNowPlayingSeries();
  Future<Either<Failure, List<TVSeries>>> getPopularSeries();
  Future<Either<Failure, List<TVSeries>>> getTopRatedSeries();
  Future<Either<Failure, TVSeriesDetail>> getSeriesDetail(int id);
  Future<Either<Failure, List<TVSeries>>> getSeriesRecommendations(int id);
  Future<Either<Failure, List<TVSeries>>> searchSeries(String query);
  Future<Either<Failure, String>> saveWatchlist(TVSeriesDetail series);
  Future<Either<Failure, String>> removeWatchlist(TVSeriesDetail series);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<TVSeries>>> getWatchlistSeries();
}
