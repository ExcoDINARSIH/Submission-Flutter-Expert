import 'package:ditonton/data/models/tv_series/tv_series_model.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

class TVSeriesTable extends Equatable {
  final int id;
  final String? name;
  final String? posterPath;
  final String? overview;

  TVSeriesTable({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
  });

  factory TVSeriesTable.fromEntity(TVSeriesDetail series) => TVSeriesTable(
        id: series.id,
        name: series.name,
        posterPath: series.posterPath,
        overview: series.overview,
      );

  factory TVSeriesTable.fromMap(Map<String, dynamic> map) => TVSeriesTable(
        id: map['id'],
        name: map['name'],
        posterPath: map['posterPath'],
        overview: map['overview'],
      );

  factory TVSeriesTable.fromDTO(TVSeriesModel series) => TVSeriesTable(
        id: series.id,
        name: series.name,
        posterPath: series.posterPath,
        overview: series.overview,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'posterPath': posterPath,
        'overview': overview,
      };

  TVSeries toEntity() => TVSeries.watchlist(
        id: id,
        name: name,
        overview: overview,
        posterPath: posterPath,
      );

  @override
  List<Object?> get props => [id, name, posterPath, overview];
}
