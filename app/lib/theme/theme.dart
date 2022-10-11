import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

final Map<int, Color> primary = {
  50: const Color(0xffEFFBF4),
  100: const Color(0xffCEF2DF),
  200: const Color(0xffAEEACA),
  300: const Color(0xff9EE5BF),
  400: const Color(0xff7EDDAA),
  500: const Color(0xff5ED495),
  600: const Color(0xff3ECC80),
  700: const Color(0xff2FB16C),
  800: const Color(0xff279158),
  900: const Color(0xff1E7145),
};



final MaterialColor primarySwatch =
    MaterialColor(const Color(0xff32BE73).value, primary);



var baseTheme = ThemeData(brightness: Brightness.light);

final materialTheme = MaterialAppData(
  themeMode: ThemeMode.light,
  theme: ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: GoogleFonts.poppins().copyWith(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      headline1: GoogleFonts.poppins(
        fontSize: 96,
        fontWeight: FontWeight.w300,
        letterSpacing: -1.5,
        color: Colors.black,
      ),
      headline2: GoogleFonts.poppins(
        fontSize: 60,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.5,
        color: Colors.black,
      ),
      headline3: GoogleFonts.poppins(
        fontSize: 48,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      headline4: GoogleFonts.poppins(
        fontSize: 34,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: Colors.black,
      ),
      headline5: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      headline6: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: Colors.black,
      ),
      subtitle1: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        color: Colors.black,
      ),
      subtitle2: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: Colors.black,
      ),
      bodyText1: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: Colors.black,
      ),
      bodyText2: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: Colors.black,
      ),
      button: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.25,
        color: Colors.black,
      ),
      caption: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: Colors.black,
      ),
      overline: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.5,
        color: Colors.black,
      ),
    ),
    primarySwatch: primarySwatch,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
      centerTitle: true,
      backgroundColor: Color(0xff32BE73),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ),
    backgroundColor: const Color(0xFFEFEFEF),
    scaffoldBackgroundColor: const Color(0xFFEFEFEF),
  ),
);

final cupertinoTheme = CupertinoAppData(
  theme:  CupertinoThemeData.raw(
      Brightness.light,
      const Color(0xff32BE73),
      const Color(0xff929292),
      CupertinoTextThemeData(
        textStyle: GoogleFonts.poppins().copyWith(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),
        primaryColor: const Color(0xff32BE73),
        dateTimePickerTextStyle: GoogleFonts.poppins(),
        navLargeTitleTextStyle: GoogleFonts.poppins(),
        navActionTextStyle: GoogleFonts.poppins(),
        pickerTextStyle: GoogleFonts.poppins(),
        tabLabelTextStyle: GoogleFonts.poppins(),
        actionTextStyle: GoogleFonts.poppins(),
        navTitleTextStyle: GoogleFonts.poppins().copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 17,
        ),
      ),
      const Color(0xff32BE73),
      const Color(0xFFEFEFEF)),
);