class Split {
  String input;
  late List<String> splitted;

  Split({required this.input});

  splitTest() {
    splitted =
        input.split(RegExp(r"(?<!\w\.\w.)(?<![A-Z][a-z]\.)(?<=\.|\?)\s"));
  }
}
