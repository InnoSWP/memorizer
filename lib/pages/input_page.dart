import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memorizer/settings/constants.dart' as clr;

import '../modules/PDF_service.dart';
import '../modules/my_button.dart';
import 'audio_page.dart';
import '../modules/text_splitter_service.dart';

List<String> splitTest(String input) {
  return input.split(RegExp(r"(?<!\w\.\w.)(?<![A-Z][a-z]\.)(?<=\.|\?)\s"));
}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: clr.kAppBarBackClr,
        title: Text('INPUT PAGE', style: TextStyle(color: clr.kAppBarTextClr)),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextField(
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
                minLines: 17,
                maxLines: 17,
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
                  fillColor: clr.kGrey,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyButton(
                      title: "Clear",
                      //size: const Size(90, 50),
                      onPressed: () {
                        _inputTextFieldController.text = "";
                        if (kDebugMode) print("clear file");
                        setState(() {
                          pdfService.clear();
                          justInput = "";
                        });
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyButton(
                    title: "Upload a File",
                    //size: Size(180, 100),
                    onPressed: () async {
                      await pdfService.uploadFile();
                      setState((){});
                      if (kDebugMode) {
                        print(pdfService.text);
                      }
                    },
                  ),
                  Text(
                    pdfService.receivedFile()
                        ? "Picked File Name: ${pdfService.fileName}"
                        : "No Picked File",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              MyButton(
                title: "Memorize",
                //size: const Size(180, 80),
                onPressed: () {
                  if (justInput != "" || pdfService.text != "") {
                    List<String> listOfSentences = <String>[];

                    //'[^\.\!\?]*[\.\!\?]'
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
                            builder: (context) =>
                                AudioPage(sentences: listOfSentences)));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}