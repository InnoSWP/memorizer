import 'package:flutter/material.dart';
import 'package:memorizer/services/pdf_service.dart';
import 'package:memorizer/services/text_splitter_service.dart';
import 'package:memorizer/settings/constants.dart' as clr;
import 'package:memorizer/widgets/buttons.dart';
import 'package:memorizer/widgets/my_app_bar.dart';

import 'audio_page.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _inputTextFieldController = TextEditingController();
  String justInput = "";
  final PdfService pdfService = PdfService();
  final TextSplitter textSplitter = TextSplitter();
  int numberOfWords = 0;

  void _clearOnPressed() {
    _inputTextFieldController.text = "";
    setState(() {
      pdfService.clear();
      justInput = "";
      numberOfWords = 0;
    });
  }

  void _uploadFileOnPressed() async {
    await pdfService.uploadFile();
    setState(() {});
  }

  void _memorizeOnPressed(BuildContext context) {
    if (justInput != "" || pdfService.text != null) {
      List<String> listOfSentences = <String>[];

      if (pdfService.text != null) {
        listOfSentences = textSplitter.parseText(pdfService.text!);
      } else if (justInput != '') {
        listOfSentences = textSplitter.parseText(justInput);
      }
      if (listOfSentences.isEmpty) {
        listOfSentences.add("Empty");
      }

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AudioPage(sentences: listOfSentences)));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text(
                "Please type text or upload a pdf file before pressing Memorize button."),
            actions: [
              TextButton(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all(clr.kOrangeAccent)),
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double kScreenHeight = MediaQuery.of(context).size.height;
    double kScreenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      onVerticalDragEnd: (DragEndDetails details) =>
          FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          // appBar: MyAppBar(input: "INPUT PAGE", actions: []).get(),
          body: Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 12, bottom: 24),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextField(
                        controller: _inputTextFieldController,
                        autocorrect: true,
                        enableInteractiveSelection: true,
                        textCapitalization: TextCapitalization.sentences,
                        enableSuggestions: true,
                        cursorColor: clr.kBnbSelectedItemClr,
                        keyboardAppearance: Brightness.dark,
                        textInputAction: TextInputAction.done,
                        readOnly: false,
                        enabled: true,
                        minLines: 20,
                        maxLines: 20,
                        decoration: InputDecoration(
                          counterText: "Number of words : $numberOfWords",
                          counterStyle: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 175, 175, 175),
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          // helperText: 'Input your text and press Memorize!',
                          helperStyle: const TextStyle(fontSize: 14),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade700,
                                width: 2,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: clr.kBnbSelectedItemClr,
                                width: 1,
                              )),
                          hintText: "Type the text or upload PDF file...",
                          hintStyle: TextStyle(
                            color: clr.kBnbSelectedItemClr,
                            fontSize: 28,
                          ),
                          filled: true,
                          fillColor: clr.blackThemeClr,
                        ),
                        onChanged: (input) {
                          setState(() {
                            justInput = input;
                            numberOfWords = input.split(" ").length - 1;
                          });
                        },
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyButton(
                            width: kScreenWidth / 5,
                            height: kScreenHeight / 24,
                            text: "Clear",
                            iconData: null,
                            onPressed: _clearOnPressed,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyButton(
                            width: kScreenWidth / 2.5,
                            height: kScreenHeight / 18,
                            text: "Upload a File",
                            iconData: null,
                            onPressed: _uploadFileOnPressed,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.fromBorderSide(BorderSide(
                                color: Colors.grey.shade700,
                                width: 1,
                              )),
                              // gradient: kDarkGradientBackground,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              child: Text(
                                pdfService.fileName != null
                                    ? 'Picked File: ${pdfService.fileName!.length < 17 ? pdfService.fileName : '${pdfService.fileName!.substring(0, 17)}...'}'
                                    : 'No Picked File',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: kScreenHeight / 10,
                              width: kScreenWidth / 2,
                              child: MyButton(
                                text: "Memorize",
                                iconData: null,
                                onPressed: () {
                                  _memorizeOnPressed(context);
                                },
                                fontSize: 30,
                              ),
                            ),
                          ]),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
