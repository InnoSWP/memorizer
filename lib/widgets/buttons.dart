import 'package:flutter/material.dart';
import 'package:memorizer/settings/constants.dart' as clr;

ButtonStyle getAudioPageButtonStyle(bool bordersOn) {
  return ButtonStyle(
    overlayColor: MaterialStateProperty.all<Color>(
      Colors.yellow.shade700,
    ),
    side: MaterialStateProperty.all<BorderSide>(BorderSide(
      width: 0.5,
      color: !bordersOn ? Colors.black : Colors.grey.shade700,
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

  //IconData? iconData;
  String? iconData;
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
        // style: ButtonStyle(
        //   backgroundColor: MaterialStateProperty.all(clr.kButtonColor),
        //   shape: MaterialStateProperty.all(RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(11.0))),
        // )
        style: getAudioPageButtonStyle(bordersOn),
        onPressed: onPressed,
        child: iconData != null
            ? SizedBox(
                height: 39,
                width: 39,
                child: Image.asset(
                  iconData!,
                  color: iconColor,
                  // fit: BoxFit,
                ),
              )
            : Text(
                text!,
                style: TextStyle(
                  fontSize: fontSize,
                  color: clr.kBnbSelectedItemClr,
                ),
              ),
      ),
    );
  }
}
