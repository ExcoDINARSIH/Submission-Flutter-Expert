import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVSeriesRecommendations usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = GetTVSeriesRecommendations(mockTVSeriesRepository);
  });

  final tId = 1;
  final tTVSeries = <TVSeries>[];

  test('should get list of series recommendations from the repository',
          () async {
        // arrange
        when(mockTVSeriesRepository.getSeriesRecommendations(tId))
            .thenAnswer((_) async => Right(tTVSeries));
        // act
        final result = await usecase.execute(tId);
        // assert
        expect(result, Right(tTVSeries));
      });
}
