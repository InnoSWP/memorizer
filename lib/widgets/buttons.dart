import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
    return Container(
      height: height,
      width: width,
      child: OutlinedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11.0))),
        ),
        onPressed: onPressed,
        child: Center(
          child: iconData != null
              ? Icon(
                  iconData,
                  size: 26.sp,
                )
              : Text(text!),
        ),
      ),
    );
  }
}

class RepeatButton extends StatelessWidget {
  RepeatButton({
    Key? key,
    this.height,
    this.width,
    required this.onPressed,
    required this.onLongPress,
    required this.repeatNumber,
  }) : super(key: key);

  double? height, width;
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final int repeatNumber;

  @override
  Widget build(BuildContext context) {
    double kHeight = 7.2.h;
    double kWidth = 19.2.w;
    return Container(
      height: kHeight,
      width: kWidth,
      child: OutlinedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11.0))),
        ),
        onPressed: onPressed,
        onLongPress: onLongPress,
        child: repeatNumber < 1
            ? Icon(
                Icons.repeat,
                // if the number of repetitiosn is negative, thne loop mode is infinite
                color: repeatNumber < 0 ? Colors.white : Colors.grey,
                size: 32.sp,
              )
            : Row(
                children: [
                  Icon(
                    Icons.repeat,
                    size: 25.sp,
                    color: Colors.white,
                  ),
                  Text(
                    repeatNumber.toString(),
                    style: TextStyle(
                      fontFeatures: const [FontFeature.subscripts()],
                      fontSize: 8.sp,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
