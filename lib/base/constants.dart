import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class ColorConstants {
  //colors
  static Color textDarkGreen = HexColor('#0E1913');
  static Color darkSlateGrey = HexColor('#475F5A');
  static Color deepGreenAccent = HexColor('#006972');
  static Color textWhite = HexColor('#F5F5F5');

  //background color
  static Color backgroundWhite = HexColor('#FFFFF');

  //navigation bar
  static Color navLabelHighlight = HexColor('#CDE7EB');
  static Color navBackground = HexColor('#E9EFF0');
}

class FontConstants {
  //font
  static const String fontBody = 'Inter';
}

class ValueConstants {
  //container margin
  static const double containerMargin = 15.0;
}

//service card textStyles

const TextStyle headerServiceCardTextStyle = TextStyle(
    fontSize: 16,
    color: Color.fromARGB(255, 0, 0, 0),
    fontWeight: FontWeight.w700);

const TextStyle subServiceCardTextStyle =
    TextStyle(fontSize: 16, color: Color.fromARGB(155, 22, 22, 22));

const TextStyle priceServiceCardTextStyle = TextStyle(
    fontSize: 16,
    color: Color.fromARGB(255, 0, 0, 0),
    fontWeight: FontWeight.w500);
