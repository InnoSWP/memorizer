import 'package:test/test.dart';

import '../lib/test_files/split.dart';

void main() {
  group('Split should work correctly1', () {
    test('value should start at 0', () {
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

    test('Split should work correctly2', () {
      const input = "Cool sentence. Yeah? That's right. Ha-haha.";
      final Split splitter = Split(input: input);

      splitter.splitTest();

      expect(splitter.splitted,
          ["Cool sentence.", "Yeah?", "That's right.", "Ha-haha."]);
    });
  });
}
