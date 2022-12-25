import 'dart:convert';

import 'package:ditonton/data/models/tv_series/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTVSeriesModel = TVSeriesModel(
    backdropPath: "/path.jpg",
    genreIds: [18],
    id: 67419,
    originalName: "Victoria",
    overview: "Overview",
    popularity: 11.520271,
    posterPath: "/path.jpg",
    firstAirDate: "2016-08-28",
    name: "Victoria",
    voteAverage: 1.39,
    voteCount: 9,
  );
  final tTVSeriesResponseModel =
  TVSeriesResponse(seriesList: <TVSeriesModel>[tTVSeriesModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
      json.decode(readJson('dummy_data/now_playing_tv_series.json'));
      // act
      final result = TVSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, tTVSeriesResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTVSeriesResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/path.jpg",
            "genre_ids": [18],
            "id": 67419,
            "original_name": "Victoria",
            "overview": "Overview",
            "popularity": 11.520271,
            "poster_path": "/path.jpg",
            "first_air_date": "2016-08-28",
            "name": "Victoria",
            "vote_average": 1.39,
            "vote_count": 9
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
