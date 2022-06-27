import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memorizer/settings/constants.dart' as clr;
import 'package:pdf_text/pdf_text.dart';

import '../modules/my_button.dart';
import 'audio_page.dart';

class InputText extends StatefulWidget {
  const InputText({Key? key}) : super(key: key);

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  final _inputTextFieldController = TextEditingController();
  File? file;
  PDFDoc? pdf;
  String pdfInput = "";
  String justInput = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: clr.kAppBarBackClr,
        title: Text("INPUT PAGE", style: TextStyle(color: clr.kAppBarTextClr)),
        centerTitle: true,
      ),
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
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyButton(
                          title: "Clear",
                          //size: const Size(90, 50),
                          onPressed: () {
                            _inputTextFieldController.text = "";
                            if (kDebugMode) print("clear file");
                            setState(() {
                              file = null;
                              pdf = null;
                              pdfInput = "";
                              justInput = "";
                            });
                          }),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MyButton(
                        title: "Upload a File",
                        //size: Size(180, 100),
                        onPressed: () async {
                          if (kDebugMode) {
                            print("Upload a File");
                          }
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            type: FileType.custom,
                            allowedExtensions: ['pdf'],
                          );

                          setState(() {
                            if (result != null) {
                              file = File(result.files.single.path!);
                              if (kDebugMode) {
                                print('file uploaded successfully');
                              }
                            } else {
                              if (kDebugMode) {
                                print("result is NULL!!!");
                              }
                            }
                          });

                          setState(() async {
                            if (file != null) {
                              pdf = await PDFDoc.fromFile(file!);
                              pdfInput = (await pdf?.text)!;
                              if (kDebugMode) {
                                print(pdfInput);
                              }
                            }
                          });
                        },
                      ),
                      Text(
                        file != null
                            ? "Picked File Name: ${file?.path.split('/').last}"
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
                          title: "Memorize",
                          //size: const Size(180, 80),
                          onPressed: () {
                            if (justInput != "" || pdfInput != "") {
                              List<String> listOfSentences = <String>[];

                              //'[^\.\!\?]*[\.\!\?]'
                              if (pdfInput != "") {
                                listOfSentences = pdfInput
                                    .replaceAll('\n', '')
                                    .split(RegExp(
                                        r"(?<!\w\.\w.)(?<![A-Z][a-z]\.)(?<=\.|\?)\s"));
                              } else if (justInput != '') {
                                listOfSentences = justInput
                                    .replaceAll('\n', '')
                                    .split(RegExp(
                                        r"(?<!\w\.\w.)(?<![A-Z][a-z]\.)(?<=\.|\?)\s"));
                              }

                              if (listOfSentences.isEmpty) {
                                listOfSentences.add("Empty");
                              }

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AudioPlayerOur(
                                          sentences: listOfSentences)));
                            }
                          },
                        ),
                      ]),
                ),
              ]),
        ),
      ),
    );
  }
}
