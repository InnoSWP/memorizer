import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  const InputText({Key? key}) : super(key: key);

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text("Input page."),
    );
  }
}
