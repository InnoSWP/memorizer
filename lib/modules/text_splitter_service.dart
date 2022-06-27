

class TextSplitter {

  List<String> parseText(String text) {
    // regular expression:
    RegExp re = RegExp(r"(\w|\s|,|')+[。.?!]*\s*");
    // get all the matches:
    List<String> matches = re.allMatches(text).map((e) => e.group(0)!).toList();
    matches.map((e) => e.endsWith(' ') ? e.substring(0, e.length - 1) : e);
    return matches;
  }
}