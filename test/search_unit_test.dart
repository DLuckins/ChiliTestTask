import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_application_1/blocks/gif/gif_bloc.dart';
import 'package:flutter_application_1/blocks/gif/gif_event.dart';
import 'package:flutter_application_1/blocks/gif/gif_state.dart';
import 'package:flutter_application_1/pages/gif_search_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockGifBloc extends Mock implements GifBloc {}

class FakeGifEvent extends Fake implements GifEvent {}

class FakeGifState extends Fake implements GifState {}

void main() {
  late MockGifBloc gifBloc;

  setUp(() {
    gifBloc = MockGifBloc();

    // Register fallback values
    registerFallbackValue(Uri.parse('https://example.com'));
    registerFallbackValue(FakeGifEvent());
    registerFallbackValue(FakeGifState());

    when(() => gifBloc.stream).thenAnswer((_) => Stream.value(InitialState()));
    when(() => gifBloc.state).thenReturn(InitialState());
  });

  testWidgets('Displays search bar', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<GifBloc>.value(
          value: gifBloc,
          child: const GifSearchPage(),
        ),
      ),
    );

    expect(find.text('Gif search'), findsOneWidget);
    expect(find.byType(SearchBar), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('Typing in search triggers GifSearch event',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<GifBloc>.value(
          value: gifBloc,
          child: const GifSearchPage(),
        ),
      ),
    );

    await tester.enterText(find.byType(SearchBar), 'wow');
    await tester.pumpAndSettle(const Duration(milliseconds: 1000));

    verify(() => gifBloc.add(GifSearch(word: 'wow'))).called(1);
  });
}
