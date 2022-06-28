import 'package:flutter/material.dart';
import 'package:memorizer/settings/constants.dart' as clr;

import '../modules/PDF_service.dart';
import '../modules/myButtons.dart';
import '../modules/my_appBar.dart';
import '../modules/text_splitter_service.dart';
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

  void _clearOnPressed() {
    _inputTextFieldController.text = "";
    setState(() {
      pdfService.clear();
      justInput = "";
    });
  }

  void _uploadFileOnPressed() async {
    await pdfService.uploadFile();
    setState(() {});
  }

  void _memorizeOnPressed() {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MyAppBar(input: "INPUT PAGE", actions: []).get(),
        body: Container(
          color: Colors.black,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 24),
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
                      minLines: 19,
                      maxLines: 19,
                      decoration: InputDecoration(
                        counterText: "Number of words : 169",
                        counterStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                        contentPadding: const EdgeInsets.all(20),
                        helperText: 'Input your text and press Memorize!',
                        helperStyle: const TextStyle(fontSize: 14),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey.shade700,
                              width: 5,
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
                        fillColor: clr.backThemeClr,
                      ),
                      onChanged: (input) {
                        setState(() {
                          justInput = input;
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
                          text: "Clear",
                          iconData: null,
                          onPressed: _clearOnPressed,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MyButton(
                          text: "Upload a File",
                          iconData: null,
                          onPressed: _uploadFileOnPressed,
                        ),
                        Text(
                          pdfService.fileName != null
                              ? "Picked File Name: ${pdfService.fileName}"
                              : "No Picked File",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyButton(
                            text: "Memorize",
                            iconData: null,
                            onPressed: _memorizeOnPressed,
                          ),
                        ]),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
