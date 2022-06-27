class TextSplitter {
  RegExp _re;

  TextSplitter(this._re);

  List<String> parseText(String text) {
    List<String> matches = _re.allMatches(text).map((e) => e.group(0)!).toList();
    matches.map((e) => e.endsWith(' ') ? e.substring(0, e.length - 1) : e);
    return matches;
  }
}