import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series/now_playing_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'now_playing_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingTVSeries])
void main() {
  late MockGetNowPlayingTVSeries mockGetNowPlayingTVSeries;
  late NowPlayingTVSeriesNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingTVSeries = MockGetNowPlayingTVSeries();
    notifier = NowPlayingTVSeriesNotifier(mockGetNowPlayingTVSeries)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  final tTVSeries = TVSeries(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTVSeriesList = <TVSeries>[tTVSeries];

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetNowPlayingTVSeries.execute())
        .thenAnswer((_) async => Right(tTVSeriesList));
    // act
    notifier.fetchNowPlayingTVSeries();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change series data when data is gotten successfully', () async {
    // arrange
    when(mockGetNowPlayingTVSeries.execute())
        .thenAnswer((_) async => Right(tTVSeriesList));
    // act
    await notifier.fetchNowPlayingTVSeries();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.series, tTVSeriesList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetNowPlayingTVSeries.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchNowPlayingTVSeries();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
