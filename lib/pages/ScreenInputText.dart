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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      textDirection: TextDirection.ltr,
      verticalDirection: VerticalDirection.down,
      children: [Text("AAA"), Text("data")],
    );
  }
}
