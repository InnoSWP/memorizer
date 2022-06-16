import 'package:flutter/material.dart';

const Color kGrey = Color.fromARGB(255, 68, 68, 68);

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

const kTextStyleSelected = TextStyle(
  color: Color(0xFFFFFFFF),
  fontSize: 24,
);

final List<String> sentencesConst = [
  'The door to the parlor opened and Mildred stood there looking in at them, looking at Beatty and then at Montag.',
  '''Behind her the walls of
the room were flooded with green and yellow and orange fireworks
sizzling and bursting to some music composed almost completely of
trap drums, tom-toms, and cymbals.''',
  '''Her mouth moved and she was
saying something but the sound covered it.''',
  '''Beatty knocked his pipe into the palm of his pink hand, studied
the ashes as if they were a symbol to be diagnosed and searched for
meaning.''',
  '''You must understand that our civilization is so vast that we can't
have our minorities upset and stirred.''',
  '''Ask yourself, What do we want
in this country, above all?''',
];
