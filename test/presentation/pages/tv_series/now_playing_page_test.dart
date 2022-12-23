import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/presentation/pages/tv_series/now_playing_page.dart';
import 'package:ditonton/presentation/provider/tv_series/now_playing_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'now_playing_page_test.mocks.dart';

@GenerateMocks([NowPlayingTVSeriesNotifier])
void main() {
  late MockNowPlayingTVSeriesNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockNowPlayingTVSeriesNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<NowPlayingTVSeriesNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(mockNotifier.state).thenReturn(RequestState.Loading);

        final progressBarFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(NowPlayingTVSeriesPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressBarFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        when(mockNotifier.state).thenReturn(RequestState.Loaded);
        when(mockNotifier.series).thenReturn(<TVSeries>[]);

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(NowPlayingTVSeriesPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(mockNotifier.state).thenReturn(RequestState.Error);
        when(mockNotifier.message).thenReturn('Error message');

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(NowPlayingTVSeriesPage()));

        expect(textFinder, findsOneWidget);
      });
}