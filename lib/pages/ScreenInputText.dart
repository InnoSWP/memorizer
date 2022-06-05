import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memorizer/settings/appColors.dart' as clr;
import 'package:pdf_text/pdf_text.dart';

import '../modules/MyButton.dart';

class InputText extends StatefulWidget {
  const InputText({Key? key}) : super(key: key);

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  File? file = null;
  PDFDoc? pdf = null;
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
                      color: clr.bnbSelectedItemClr,
                    )),
                filled: true,
                hintText: "Type the text that you want to memorize here...",
                hintStyle: TextStyle(
                  color: clr.bnbSelectedItemClr,
                  fontSize: 30,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                fillColor: clr.grey,
              ),
              onChanged: (input) {
                print("Changed");
              },
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Text(
              "OR",
              style: TextStyle(fontSize: 50, color: clr.bnbSelectedItemClr),
            ),
            MyButton(
                title: "Upload a File",
                size: Size(180, 100),
                onPressed: () async {
                  print("Upload a File");
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );

                  setState((){
                    if (result != null) {
                      file = File(result.files.single.path!);
                      print('file uploaded successfully');
                    }
                    else {
                      print("result is NULL!!!");
                    }
                  });

                  setState(() async {
                    if (file != null) {
                      pdf = await PDFDoc.fromFile(file!);
                      pdf_input = (await pdf?.text)!;
                      print(pdf_input);
                    }
                  });
                },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "${file != null ? "Picked File Name: ${file?.path.split('/'). last}" : "No Picked File"}",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                MyButton(
                    title: "Clear",
                    size: Size(90, 50),
                    onPressed: (){
                      print("clear file");
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
                print("Memorize Now!");
              },
            ),
          ],
        ),
      ),
    );
  }
}


