import 'package:flutter/material.dart';
import 'package:memorizer/settings/constants.dart' as clr;

class MyButton extends StatelessWidget {
  final String title;
  final Size size;
  final VoidCallback onPressed;

  const MyButton({
    required this.title,
    required this.size,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(size),
        backgroundColor: MaterialStateProperty.all<Color?>(clr.kGrey),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          color: clr.kBnbSelectedItemClr,
        ),
      ),
    );
  }
}
