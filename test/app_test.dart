import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorizer/main.dart';
import 'package:memorizer/modules/my_button.dart';
import 'package:memorizer/test_files/split.dart';

void main() {
  // unit test----
  group('Split should work correctly0', () {
    test('Split should work correctly1 ', () {
      const input = "AAA. BBb!";
      final Split splitter = Split(input: input);

      splitter.splitTest();

      expect(splitter.splitted, ["AAA.", "BBb!"]);
    });

    test('Split should work correctly2', () {
      const input = "Trata-ta. God my god. It's may be working... AAA? BBb!";
      final Split splitter = Split(input: input);

      splitter.splitTest();

      expect(splitter.splitted, [
        "Trata-ta.",
        "God my god.",
        "It's may be working...",
        "AAA?",
        "BBb!"
      ]);
    });
    test('Split should work correctly3', () {
      const input = "Cool sentence. Yeah? That's right. Ha-haha.";
      final Split splitter = Split(input: input);

      splitter.splitTest();

      expect(splitter.splitted,
          ["Cool sentence.", "Yeah?", "That's right.", "Ha-haha."]);
    });
  });

  //widget test----
  group("Widget test", () {
    testWidgets("Find TextField", (WidgetTester tester) async {
      await tester.pumpWidget(APP());
      expect(find.byType(MaterialApp), findsOneWidget);
    });
    testWidgets("Find Buttons", (WidgetTester tester) async {
      await tester.pumpWidget(APP());
      expect(find.byType(MyButton), findsNWidgets(3));
    });
    testWidgets("Find AppBar", (WidgetTester tester) async {
      await tester.pumpWidget(APP());
      expect(find.byType(AppBar), findsOneWidget);
    });
    testWidgets("Find Text", (WidgetTester tester) async {
      await tester.pumpWidget(APP());
      expect(find.byType(Text), findsWidgets);
    });
  });
}
