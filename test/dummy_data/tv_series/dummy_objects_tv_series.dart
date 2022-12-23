import 'package:ditonton/data/models/tv_series/tv_series_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series_detail.dart';

final testTVSeries = TVSeries(
  posterPath: "/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg",
  popularity: 369.594,
  id: 76043,
  backdropPath: "/suopoADq0k8YZr4dQXcU6pToj6s.jpg",
  voteAverage: 8.3,
  overview:
  "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
  firstAirDate: "2011-04-17",
  genreIds: [10765, 18, 10759, 9648],
  voteCount: 11504,
  name: "Game-of-Thrones",
  originalName: "Game-of-Thrones",
);

final testTVSeriesList = [testTVSeries];

final testTVSeriesDetail = TVSeriesDetail(
  posterPath: "posterPath",
  id: 76043,
  backdropPath: "backdropPath",
  voteAverage: 8.3,
  overview: "overview",
  firstAirDate: DateTime(2011 - 04 - 17),
  numberOfEpisodes: 73,
  numberOfSeasons: 8,
  genres: [
    Genre(id: 10765, name: "Sci-Fi & Fantasy"),
    Genre(id:18, name: "Drama"),
    Genre(id: 10759, name: "Action & Adventures"),
    Genre(id: 9648, name: "Mystery"),
  ],
  voteCount: 11504,
  name: "name",
  originalName: "originalName",
);

final testTVSeriesCache = TVSeriesTable(
  id: 76043,
  overview: "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
  name: "Game-of-Thrones",
  posterPath: "/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg",
);

final testTVSeriesCacheMap = {
  "id": 76043,
  "overview": "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
  "name": "Game-of-Thrones",
  "posterPath": "/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg",
};

final testTVSeriesFromCache = TVSeries.watchlist(
  id: 76043,
  overview: "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
  name: "Game-of-Thrones",
  posterPath: "/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg",
);

final testWatchlistTVSeries = TVSeries.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTVSeriesTable = TVSeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTVSeriesMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};
