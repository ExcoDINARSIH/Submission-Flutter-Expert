import 'package:equatable/equatable.dart';
import 'package:ditonton/domain/entities/genre.dart';

class TVSeriesDetail extends Equatable {
  const TVSeriesDetail({
    required this.backdropPath,
    required this.firstAirDate,
    required this.genres,
    required this.id,
    required this.name,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });

  final String? backdropPath;
  final DateTime firstAirDate;
  final List<Genre> genres;
  final int id;
  final String name;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final String originalName;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final int voteCount;

  @override
  List<Object?> get props => [
    backdropPath,
    firstAirDate,
    genres,
    id,
    name,
    numberOfEpisodes,
    numberOfSeasons,
    originalName,
    overview,
    posterPath,
    voteAverage,
    voteCount,
  ];
}