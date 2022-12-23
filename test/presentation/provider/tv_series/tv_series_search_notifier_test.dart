import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/search_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series/tv_series_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTVSeries])
void main() {
  late TVSeriesSearchNotifier provider;
  late MockSearchTVSeries mockSearchTVSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTVSeries = MockSearchTVSeries();
    provider = TVSeriesSearchNotifier(searchTVSeries: mockSearchTVSeries)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTVSeriesModel = TVSeries(
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
  final tTVSeriesList = <TVSeries>[tTVSeriesModel];
  final tQuery = 'gameofthrones';

  group('search series', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchTVSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tTVSeriesList));
      // act
      provider.fetchSeriesSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
            () async {
          // arrange
          when(mockSearchTVSeries.execute(tQuery))
              .thenAnswer((_) async => Right(tTVSeriesList));
          // act
          await provider.fetchSeriesSearch(tQuery);
          // assert
          expect(provider.state, RequestState.Loaded);
          expect(provider.searchResult, tTVSeriesList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchTVSeries.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchSeriesSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
