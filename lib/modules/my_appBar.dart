import 'package:flutter/material.dart';
import 'package:memorizer/settings/constants.dart' as clr;

class MyAppBar {
  late final String input;
  List<Widget> actions;

  MyAppBar({required this.input, required this.actions});

  AppBar get() {
    return AppBar(
      actions: actions,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Colors.grey.shade700,
        ),
      ),
      backgroundColor: clr.kAppBarBackClr,
      title: Text(
        input,
        style: TextStyle(color: clr.kAppBarTextClr),
      ),
      centerTitle: true,
    );
  }
}
