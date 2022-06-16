import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memorizer/settings/constants.dart' as clr;
import 'package:pdf_text/pdf_text.dart';

import '../modules/my_button.dart';

class InputText extends StatefulWidget {
  const InputText({Key? key}) : super(key: key);

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  File? file;
  PDFDoc? pdf;
  String pdf_input = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              minLines: 6,
              maxLines: 12,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: clr.kBnbSelectedItemClr,
                    )),
                filled: true,
                hintText: "Type the text that you want to memorize here...",
                hintStyle: TextStyle(
                  color: clr.kBnbSelectedItemClr,
                  fontSize: 30,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                fillColor: clr.kGrey,
              ),
              onChanged: (input) {
                if (kDebugMode) {
                  print("Changed");
                }
              },
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Text(
              "OR",
              style: TextStyle(fontSize: 50, color: clr.kBnbSelectedItemClr),
            ),
            MyButton(
              title: "Upload a File",
              size: Size(180, 100),
              onPressed: () async {
                if (kDebugMode) {
                  print("Upload a File");
                }
                FilePickerResult? result = await FilePicker.platform.pickFiles(
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
                    pdf_input = (await pdf?.text)!;
                    if (kDebugMode) {
                      print(pdf_input);
                    }
                  }
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  file != null
                      ? "Picked File Name: ${file?.path.split('/').last}"
                      : "No Picked File",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                MyButton(
                    title: "Clear",
                    size: const Size(90, 50),
                    onPressed: () {
                      if (kDebugMode) {
                        print("clear file");
                      }
                      setState(() {
                        file = null;
                      });
                    })
              ],
            ),
            MyButton(
              title: "Memorize Now!",
              size: Size(180, 80),
              onPressed: () {
                if (kDebugMode) {
                  print("Memorize Now!");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
