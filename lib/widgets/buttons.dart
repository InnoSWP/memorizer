import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:memorizer/settings/constants.dart' as clr;
import 'package:sizer/sizer.dart';

ButtonStyle getAudioPageButtonStyle() {
  return ButtonStyle(
    overlayColor: MaterialStateProperty.all<Color>(
      Colors.yellow.shade700,
    ),
    side: MaterialStateProperty.all<BorderSide>(BorderSide(
      width: 1.75,
      color: Colors.grey.shade700,
    )),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(9),
    )),
  );
}

// class MyButton extends OutlinedButton {
//   final IconData? iconData;
//   final String? text;

//   @override
//   final VoidCallback onPressed;

//   MyButton({
//     this.text,
//     this.iconData,
//     required this.onPressed,
//     Key? key,
//   }) : super(
//           style: getAudioPageButtonStyle(),
//           child: iconData != null
//               ? Icon(
//                   iconData,
//                   color: Colors.white,
//                   size: 45,
//                 )
//               : Text(
//                   text!,
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: clr.kBnbSelectedItemClr,
//                   ),
//                 ),
//           onPressed: onPressed,
//         );
// }

class MyButton extends StatelessWidget {
  MyButton({
    Key? key,
    required this.onPressed,
    this.iconData,
    this.text,
    this.fontSize,
    this.iconColor = Colors.white,
    this.height,
    this.width,
  }) : super(key: key);

  final VoidCallback onPressed;
  IconData? iconData;
  Color? iconColor;
  String? text;
  double? fontSize;
  double? height;
  double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(clr.kButtonColor),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11.0))),
        ),
        onPressed: onPressed,
        child: Center(
          child: iconData != null
              ? Icon(
                  iconData,
                  color: iconColor,
                  size: 26.sp,
                )
              : Text(
                  text!,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: clr.kBnbSelectedItemClr,
                  ),
                ),
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
          backgroundColor: MaterialStateProperty.all(clr.kButtonColor),
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
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
