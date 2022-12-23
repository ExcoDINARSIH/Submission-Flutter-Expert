import 'package:ditonton/common/network_info.dart';
import 'package:ditonton/data/datasources/movies/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_series/tv_series_local_data_source.dart';
import 'package:ditonton/data/datasources/movies/db/database_helper.dart';
import 'package:ditonton/data/datasources/tv_series/db/database_helper_tv_series.dart';
import 'package:ditonton/data/datasources/movies/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_series/tv_series_remote_data_source.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/domain/usecases/tv_series/remove_watchlist_series.dart';
import 'package:ditonton/presentation/provider/tv_series/watchlist_tv_series_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  TVSeriesRepository,
  MovieRemoteDataSource,
  TVSeriesRemoteDataSource,
  MovieLocalDataSource,
  TVSeriesLocalDataSource,
  DatabaseHelper,
  DatabaseHelperSeries,
  NetworkInfo,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
