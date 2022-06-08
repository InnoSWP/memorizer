import 'package:flutter/material.dart';
import 'package:memorizer/settings/appColors.dart' as clr;

class MyButton extends StatefulWidget {
  final String title;
  final Size size;
  final VoidCallback onPressed;

  const MyButton({
    required this.title,
    required this.size,
    required this.onPressed,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(widget.size),
        backgroundColor: MaterialStateProperty.all<Color?>(clr.buttonsClr),
      ),
      onPressed: widget.onPressed,
      child: Text(
        widget.title,
        style: TextStyle(
          fontSize: 20,
          color: clr.bnbSelectedItemClr,
        ),
      ),
    );
  }
}
