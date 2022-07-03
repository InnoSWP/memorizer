import 'package:flutter/material.dart';
import 'package:memorizer/settings/constants.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyTheme {

  static final light = ThemeData(
    // switchTheme: SwitchThemeData(
    //   thumbColor: MaterialStateProperty.all(mainColor_dark),
    //   trackColor: MaterialStateProperty.all(backWidColor_dark),
    // ),

    selectedRowColor: textContainerBorder_light,

    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            backgroundColor: backPopUpButton_light,
            primary: backWidColor_dark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ))),

    scaffoldBackgroundColor: scaffoldBack_light,

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: const CircleBorder(
        side: BorderSide(width: 2, color: floatButtonBorder_light),
      ),
      backgroundColor: floatButtonBack_light,
      foregroundColor: floatButtonIcon_light,
      splashColor: floatButtonSplash_light,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        primary: mainColor_light,
        backgroundColor: backWidColor_light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45),
        ),
        side: BorderSide.none
        //  (
        // width: 0.1,
        //  color: Colors.black,
        // )
        ,
      ),
    ),
    hintColor: appBarHint_light,

    dialogTheme: DialogTheme(
        backgroundColor: backPopUp_light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        titleTextStyle: const TextStyle(
          color: textPopUp_light,
          fontWeight: FontWeight.w700,
          fontSize: 24,
          letterSpacing: 3,
        ),
        contentTextStyle: const TextStyle(
            color: textPopUp_light,
            fontWeight: FontWeight.w400,
            fontSize: 18,
            letterSpacing: 2)),

    appBarTheme: const AppBarTheme(
      shadowColor: appBarShadow_light,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(14), bottomLeft: Radius.circular(14)),
        side: BorderSide(
          color: appBarHintBorder_light,
        ),
      ),
      centerTitle: true,
      //toolbarHeight: 45,
      titleTextStyle: TextStyle(color: appBarTitle_light, fontSize: 20),
    ),

    inputDecorationTheme: InputDecorationTheme(
        counterStyle: const TextStyle(
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.all(20),
        helperStyle: const TextStyle(fontSize: 14),
        hintStyle: const TextStyle(
          color: mainColor_light,
          fontSize: 28,
        ),
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: textContainerBorder_light,
              width: 1,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: mainColor_light,
              width: 2,
            )),
        fillColor: backWidColor_light),

    colorScheme: ColorScheme.highContrastLight(
      secondary: backContainer_light,
    ),
    textTheme: TextTheme(
        bodyText1: TextStyle(color: mainDarkerColor_light, fontSize: 25),
        bodyText2: TextStyle(fontSize: 24, color: textUnselectedRow_light),
        subtitle1: const TextStyle(fontSize: 14)),
    textSelectionTheme: TextSelectionThemeData(
        selectionColor: textSelection_light,
        selectionHandleColor: mainColor_light,
        cursorColor: mainColor_light),
  );
  static final dark = ThemeData(
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(mainColor_dark),
      trackColor: MaterialStateProperty.all(backWidColor_dark),
    ),
    inputDecorationTheme: InputDecorationTheme(
      counterStyle: const TextStyle(
        fontSize: 14,
      ),
      contentPadding:
          const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
      helperStyle: const TextStyle(fontSize: 14),
      hintStyle: const TextStyle(
        color: mainColor_dark,
        fontSize: 28,
      ),
      filled: true,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: textContainerBorder_dark,
            width: 1,
          )),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: mainColor_dark,
            width: 2,
          )),
      fillColor: backWidColor_dark,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      shape: CircleBorder(
        side: BorderSide(
          color: mainColor_dark,
        ),
      ),
      backgroundColor: floatButtonBack_dark,
      foregroundColor: mainColor_dark,
      splashColor: floatButtonSplash_dark,
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        primary: mainColor_dark,
        backgroundColor: backWidColor_dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        side: BorderSide.none,
      ),
    ),

    scaffoldBackgroundColor: scaffoldBack_dark,

    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            backgroundColor: backPopUpButton_dark,
            primary: backWidColor_dark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ))),

    dialogTheme: DialogTheme(
        backgroundColor: backWidColor_dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        titleTextStyle: const TextStyle(
          color: mainColor_dark,
          fontWeight: FontWeight.w700,
          fontSize: 24,
          letterSpacing: 3,
        ),
        contentTextStyle: const TextStyle(
            color: mainColor_dark,
            fontWeight: FontWeight.w400,
            fontSize: 18,
            letterSpacing: 2)),

    hintColor: appBarHintBorder_dark,

    colorScheme: const ColorScheme.highContrastDark(
      secondary: backWidColor_dark, //back container color
    ),

    textTheme: TextTheme(
        bodyText1: const TextStyle(color: mainColor_dark, fontSize: 25),
        bodyText2: TextStyle(fontSize: 24, color: textUnselectedRow_dark),
        subtitle1: const TextStyle(fontSize: 14)),

    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: textSelection_dark,
      selectionHandleColor: mainColor_dark,
      cursorColor: mainColor_dark,
    ),

    appBarTheme: const AppBarTheme(
      shadowColor: appBarShadow_dark,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(14), bottomLeft: Radius.circular(14)),
        side: BorderSide(
          color: appBarHintBorder_dark,
        ),
      ),
      centerTitle: true,
      //toolbarHeight: 45,
      titleTextStyle: TextStyle(color: appBarTitle_dark, fontSize: 20),
    ),

    //border of the container
    selectedRowColor: textContainerBorder_dark,
  );
}
