import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memorizer/modules/text_splitter_service.dart';

void main() {
  group('Split should work correctly1', () {
    test('value should start at 0', () {
      const input = "AAA. BBb!";
      final TextSplitter splitter = TextSplitter();
      final expected = ["AAA.", "BBb!"];
      final res = splitter.parseText(input);

      expect(res, expected);
    });

    test('Split should work correctly2', () {
      const input = "Trata-ta. God my god. It's may be working... AAA? BBb!";
      final expected = [
        "Trata-ta.",
        "God my god.",
        "It's may be working...",
        "AAA?",
        "BBb!"
      ];
      final TextSplitter splitter = TextSplitter();
      final res = splitter.parseText(input);


      expect(res, expected);
    });

    test('Split should work correctly2', () {
      const input = "Cool sentence. Yeah? That's right. Ha-haha.";
      const expected = ["Cool sentence.", "Yeah?", "That's right.", "Ha-haha."];
      final TextSplitter splitter = TextSplitter();
      final res = splitter.parseText(input);
      expect(res, expected);
    });
  });
}
