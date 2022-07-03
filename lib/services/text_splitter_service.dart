class TextSplitter {
  final RegExp _re = RegExp(r"(?<!\w\.\w.)(?<![A-Z][a-z]\.)(?<=\.|\?)\s");

  List<String> parseText(String text) {
    List<String> matches = text.trim().split(_re);
    print('Inside parser, matches: $matches');
    return matches;
  }
}