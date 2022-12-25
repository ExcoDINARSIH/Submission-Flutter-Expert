import 'package:ditonton/common/network_info.dart';
import 'package:ditonton/data/datasources/movies/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_series/tv_series_local_data_source.dart';
import 'package:ditonton/data/datasources/movies/db/database_helper.dart';
import 'package:ditonton/data/datasources/tv_series/db/database_helper_tv_series.dart';
import 'package:ditonton/data/datasources/movies/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_series/tv_series_remote_data_source.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/io_client.dart';

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
  MockSpec<IOClient>(as: #MockHttpClient)
])
void main() {}
