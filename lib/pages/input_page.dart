import 'package:flutter/material.dart';
import 'package:memorizer/services/pdf_service.dart';
import 'package:memorizer/services/text_splitter_service.dart';
import 'package:memorizer/widgets/buttons.dart';
import 'package:memorizer/widgets/my_app_bar.dart';
import 'package:sizer/sizer.dart';

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
    if (justInput != '' && pdfService.text != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text(
                "Please either enter a text or upload a pdf to start memorizing."),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    } else if (justInput != "" || pdfService.text != null) {
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
          appBar: MyAppBar(input: "INPUT PAGE", actions: [], context: context)
              .get(),
          body: Padding(
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
                      keyboardAppearance: Theme.of(context).brightness,
                      textInputAction: TextInputAction.done,
                      readOnly: false,
                      enabled: true,
                      minLines: 24,
                      maxLines: 24,
                      decoration: InputDecoration(
                        counterText: "Number of words : $numberOfWords",
                        helperText: 'Input your text and press Memorize!',
                        hintText: "Type the text or upload PDF file...",
                      ),
                      onChanged: (input) {
                        setState(() {
                          justInput = input.trim();

                          numberOfWords = input.trim().split(" ").length;
                        });
                      },
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
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
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyButton(
                          width: 40.w,
                          height: 5.5.h,
                          text: "Upload a File",
                          iconData: null,
                          fontSize: 15.sp,
                          onPressed: _uploadFileOnPressed,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.fromBorderSide(BorderSide(
                                width: 1,
                                color: Theme.of(context).selectedRowColor)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            child: Text(
                              pdfService.fileName != null
                                  ? 'Picked File: ${pdfService.fileName!.length < 17 ? pdfService.fileName : '${pdfService.fileName!.substring(0, 17)}...'}'
                                  : 'No Picked File',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10.h,
                            width: 50.w,
                            child: MyButton(
                              text: "Memorize",
                              iconData: null,
                              fontSize: 26.sp,
                              onPressed: () {
                                _memorizeOnPressed(context);
                              },
                              //  fontSize: 30,
                            ),
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
