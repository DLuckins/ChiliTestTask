import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/gif_desc_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GifDescPage Widget Tests', () {
    late Map<String, dynamic> gifInfo;

    setUp(() {
      gifInfo = {
        "title": "Dancing guy",
        "images": {
          "fixed_height": {"url": "https://something.com/dancing_guy.gif"}
        },
        "user": {"avatar_url": "https://something.com/some_avatar.gif"},
        "username": "Guy123",
        "import_datetime": "2023-02-08",
        "rating": "PG",
      };
    });

    testWidgets('renders correctly with full data',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => GifDescPage(),
              settings: RouteSettings(arguments: gifInfo),
            );
          },
        ),
      );

      expect(find.text('Dancing guy'), findsOneWidget);
      expect(find.byType(FadeInImage), findsNWidgets(2));
      expect(find.text('Guy123'), findsOneWidget);
      expect(find.text('Guest'), findsNothing);
      expect(find.text('Posted on 2023-02-08'), findsOneWidget);
      expect(find.text('Rating: PG'), findsOneWidget);
    });

    testWidgets('renders Guest if username is missing',
        (WidgetTester tester) async {
      gifInfo["username"] = "";

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => GifDescPage(),
              settings: RouteSettings(arguments: gifInfo),
            );
          },
        ),
      );

      expect(find.text('Guest'), findsOneWidget);
      expect(find.text('Guy123'), findsNothing);
    });

    testWidgets('handles missing user avatar', (WidgetTester tester) async {
      gifInfo["user"] = null;

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => GifDescPage(),
              settings: RouteSettings(arguments: gifInfo),
            );
          },
        ),
      );

      expect(find.byType(FadeInImage), findsOneWidget);
      expect(find.text('Dancing guy'), findsOneWidget);
    });
  });
}
