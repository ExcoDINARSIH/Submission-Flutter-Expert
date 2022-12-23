import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = GetPopularTVSeries(mockTVSeriesRepository);
  });

  final tTVSeries = <TVSeries>[];

  group('Get Popular TV Series Tests', () {
    group('execute', () {
      test(
          'should get list of series from the repository when execute function is called',
              () async {
            // arrange
            when(mockTVSeriesRepository.getPopularSeries())
                .thenAnswer((_) async => Right(tTVSeries));
            // act
            final result = await usecase.execute();
            // assert
            expect(result, Right(tTVSeries));
          });
    });
  });
}
