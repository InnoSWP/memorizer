class TextSplitter {
  RegExp _re = RegExp(r"(?<!\w\.\w.)(?<![A-Z][a-z]\.)(?<=\.|\?)\s");

  //TextSplitter(this._re);

  List<String> parseText(String text) {
    List<String> matches = text.split(_re);
    print('Inside parser, matches: $matches');
    return matches;
  }
}