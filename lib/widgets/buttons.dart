import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  MyButton(
      {Key? key,
      required this.onPressed,
      this.iconData,
      this.text,
      this.fontSize = 20,
      this.iconColor = Colors.white,
      this.height,
      this.width,
      this.bordersOn = false})
      : super(key: key);

  final VoidCallback onPressed;
  IconData? iconData;
  Color? iconColor;
  String? text;
  double? fontSize;
  double? height;
  double? width;
  bool bordersOn;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: OutlinedButton(
        onPressed: onPressed,
        child: iconData != null
            ? SizedBox(
                height: 39,
                width: 39,
                child: Icon(
                  iconData!,
                ),
              )
            : Text(
                text!,
                style: TextStyle(
                  fontSize: fontSize,
                ),
              ),
      ),
    );
  }
}
