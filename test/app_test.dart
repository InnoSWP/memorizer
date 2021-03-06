import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memorizer/main.dart' as MAIN;
import 'package:memorizer/widgets/buttons.dart';
import 'package:memorizer/services/text_splitter_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  // unit test-----
  group('TextSplitter should work correctly0', () {
    test('TextSplitter should work correctly1 ', () {
      const input = "AAA. BBb!";
      final TextSplitter splitter = TextSplitter();

      final res = splitter.parseText(input);

      expect(res, ["AAA.", "BBb!"]);
    });
    test('TextSplitter should work correctly2', () {
      const input = "Trata-ta. God my god. It's may be working... AAA? BBb!";
      final TextSplitter splitter = TextSplitter();

      final res = splitter.parseText(input);

      expect(res, [
        "Trata-ta.",
        "God my god.",
        "It's may be working...",
        "AAA?",
        "BBb!"
      ]);
    });
    test('TextSplitter should work correctly3', () {
      const input = "Cool sentence. Yeah? That's right. Ha-haha.";
      final TextSplitter splitter = TextSplitter();

      final res = splitter.parseText(input);

      expect(res, ["Cool sentence.", "Yeah?", "That's right.", "Ha-haha."]);
    });
  });
  //widget test----
  group("Widget test", () {
    testWidgets("Find TextField", (WidgetTester tester) async {
      await tester.pumpWidget(MAIN.App());
      expect(find.byType(MaterialApp), findsOneWidget);
    });
    testWidgets("Find Buttons", (WidgetTester tester) async {
      await tester.pumpWidget(MAIN.App());
      expect(find.byType(MyButton), findsNWidgets(3));
    });
    testWidgets("Find AppBar", (WidgetTester tester) async {
      await tester.pumpWidget(MAIN.App());
      expect(find.byType(AppBar), findsOneWidget);
    });
    testWidgets("Find Text", (WidgetTester tester) async {
      await tester.pumpWidget(MAIN.App());
      expect(find.byType(Text), findsWidgets);
    });
    testWidgets("Find Text", (WidgetTester tester) async {
      await tester.pumpWidget(MAIN.App());
      expect(find.byType(Text), findsWidgets);
    });
  });

  // integration test TextField

  group('Integration TextField tapping test', () {
    testWidgets(
      'TextField_test_1 : tap on the textField, enter letters',
      (tester) async {
        await tester.pumpWidget(MAIN.App());

        expect(
            find.text('Type the text or upload PDF file...'), findsOneWidget);

        // Input this text
        const inputText = 'Hello there, this is an input.';

        await tester.enterText(find.byType(TextField), inputText);

        expect(find.text(inputText), findsOneWidget);
      },
    );
    testWidgets(
      'TextField_test_2 : tap on the textField, enter letters',
      (tester) async {
        await tester.pumpWidget(MAIN.App());

        expect(
            find.text('Type the text or upload PDF file...'), findsOneWidget);

        // Input this text
        const inputText =
            'Hervwe ewtetyrnb rw llo th qcrewr qwervewrb euwrbere, this i terbtbtetqsewrwver an input.';

        await tester.enterText(find.byType(TextField), inputText);

        expect(find.text(inputText), findsOneWidget);
      },
    );
    testWidgets(
      'TextField_test_3 : tap on the textField, enter letters',
      (tester) async {
        await tester.pumpWidget(MAIN.App());

        expect(
            find.text('Type the text or upload PDF file...'), findsOneWidget);

        // Input this text
        const inputText =
            'Hewvinwr GHw erv /.werlk /wvp.er fds/fs /r; WE[r GEVPtroer gerotbkert  remtkert/ /ert/be 90(0&*&%4 EWJIORGU,IOTBTE Tello there, this is an input.';

        await tester.enterText(find.byType(TextField), inputText);

        expect(find.text(inputText), findsOneWidget);
      },
    );
  });

  // integration test TextField

  group('Integration TextField tapping test', () {
    testWidgets(
      'TextField_test_1 : tap on the textField, enter letters',
      (tester) async {
        await tester.pumpWidget(MAIN.App());

        expect(
            find.text('Type the text or upload PDF file...'), findsOneWidget);

        // Input this text
        const inputText = 'Hello there, this is an input.';

        await tester.enterText(find.byType(TextField), inputText);

        expect(find.text(inputText), findsOneWidget);
      },
    );
    testWidgets(
      'TextField_test_2 : tap on the textField, enter letters',
      (tester) async {
        await tester.pumpWidget(MAIN.App());

        expect(
            find.text('Type the text or upload PDF file...'), findsOneWidget);

        // Input this text
        const inputText =
            'Hervwe ewtetyrnb rw llo th qcrewr qwervewrb euwrbere, this i terbtbtetqsewrwver an input.';

        await tester.enterText(find.byType(TextField), inputText);

        expect(find.text(inputText), findsOneWidget);
      },
    );
    testWidgets(
      'TextField_test_3 : tap on the textField, enter letters',
      (tester) async {
        await tester.pumpWidget(MAIN.App());

        expect(
            find.text('Type the text or upload PDF file...'), findsOneWidget);

        // Input this text
        const inputText =
            'Hewvinwr GHw erv /.werlk /wvp.er fds/fs /r; WE[r GEVPtroer gerotbkert  remtkert/ /ert/be 90(0&*&%4 EWJIORGU,IOTBTE Tello there, this is an input.';

        await tester.enterText(find.byType(TextField), inputText);

        expect(find.text(inputText), findsOneWidget);
      },
    );
  });
}
