import 'package:flutter/foundation.dart';

class TextSplitter {
  final RegExp _re = RegExp(r"(?<!\w\.\w.)(?<![A-Z][a-z]\.)(?<=\.|\?)\s");

  List<String> parseText(String text) {
    List<String> matches = text.trim().split(_re);
    for (int i = 0; i < matches.length; ++i) {
      matches[i] = matches[i].replaceAll('\n', ' ');
      //print(listOfSentences[i]);
    }
    if (kDebugMode) {
      print('Inside parser, matches: $matches');
    }
    return matches;
  }
}