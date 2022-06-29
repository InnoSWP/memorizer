import 'package:flutter/material.dart';
import 'package:memorizer/settings/constants.dart' as clr;

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
    this.fontSize = 20,
    this.iconColor = Colors.white,
  }) : super(key: key);

  final VoidCallback onPressed;
  IconData? iconData;
  Color? iconColor;
  String? text;
  double? fontSize;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: iconData != null
          ? Icon(
              iconData,
              color: iconColor,
              size: 45,
            )
          : Text(
              text!,
              style: TextStyle(
                fontSize: fontSize,
                color: clr.kBnbSelectedItemClr,
              ),
            ),
    );
  }
}
