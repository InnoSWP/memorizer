
import 'package:flutter/material.dart';

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
