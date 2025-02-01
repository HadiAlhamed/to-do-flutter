import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color(0xFF4e5ae8);

const Color orangeClr = Color(0xCFFF8746);

const Color pinkClr = Color(0xFFff4667);

const Color white = Colors.white;

const Color primaryClr = bluishClr;

const Color darkGreyClr = Color(0xFF121212);

const Color darkHeaderClr = Color(0xFF424242);
TextStyle get headingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.white : Colors.black,
    ),
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.white : Colors.black,
    ),
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.white : Colors.black,
    ),
  );
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? Colors.white : Colors.black,
    ),
  );
}

TextStyle get bodyStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? Colors.white : Colors.black,
    ),
  );
}

TextStyle get body2Style {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? Colors.grey[200] : Colors.black,
    ),
  );
}

class Themes {
  static final light = ThemeData(
    primaryColor: white,
    scaffoldBackgroundColor: white,
    brightness: Brightness.light,
    useMaterial3: true,
  );

  static final dark = ThemeData(
    primaryColor: darkGreyClr,
    scaffoldBackgroundColor: darkGreyClr,
    brightness: Brightness.dark,
    useMaterial3: true,
  );
}
