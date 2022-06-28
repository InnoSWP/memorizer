import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color backThemeClr = Color.fromARGB(255, 68, 68, 68);


// Bottom Navigation Bar
Color kBnbBackClr = const Color.fromRGBO(24, 24, 24, 1);
Color kBnbSelectedItemClr = Colors.yellow.shade700;
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
  textStyle: TextStyle(
    color: Colors.yellow.shade700, //Color(0xFFFFFFFF),
    fontSize: 24,
  ),
);

// Info Page Colors
const kInfoBackgroundColor = Color(0xff929292);

const kContainerColor = Color(0xFF363636);
