import 'package:flutter/material.dart';
import 'package:memorizer/settings/constants.dart' as clr;

class MyButton extends StatelessWidget {
  final String title;

  final VoidCallback onPressed;

  const MyButton({
    required this.title,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        //fixedSize: MaterialStateProperty.all<Size>(size),
        overlayColor: MaterialStateProperty.all<Color>(Colors.yellow.shade700),
        backgroundColor: MaterialStateProperty.all<Color?>(clr.backThemeClr),
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
