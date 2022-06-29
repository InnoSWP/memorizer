import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color blackThemeClr = Color.fromARGB(255, 27, 27, 27);
const Color kOrangeAccent = Color.fromARGB(255, 251, 192, 45);
const Color kInputTextColor = Color.fromARGB(255, 190, 190, 190);
const Color kButtonColor = Color.fromARGB(255, 31, 31, 31);

// Bottom Navigation Bar
Color kBnbBackClr = const Color.fromRGBO(24, 24, 24, 1);
Color kBnbSelectedItemClr = kOrangeAccent;
Color kBnbUnselectedItemClr = Colors.white70;
// BNB Items
Color kBackClrBnbItem_1 = const Color.fromRGBO(24, 24, 24, 1);
Color kBackClrBnbItem_2 = const Color.fromRGBO(24, 24, 24, 1);
// AppBar
Color kAppBarBackClr = const Color.fromRGBO(24, 24, 24, 1);
Color kAppBarTextClr = Colors.white;

// Left Menu Colors
Color kLeftMenuClr = const Color.fromRGBO(24, 24, 24, 0.95);
Color kLeftMenuItemsClr = Colors.white;

// Audio Player Page colors
const kBackgroundColor = Color(0xFF242424);
const kDarkGradientBackground = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF9400D3),
    Color(0xFF4B0082),
  ],
);
const kTextStyleMain = TextStyle(
  color: Color(0x96FFFFFF),
  fontSize: 24,
);
var kTextStyleSelected = GoogleFonts.roboto(
  textStyle: const TextStyle(
    color: kOrangeAccent, //Color(0xFFFFFFFF),
    fontSize: 24,
  ),
);

// Info Page Colors
const kInfoBackgroundColor = Color(0xff929292);

const kContainerColor = Color.fromARGB(255, 54, 54, 54);
