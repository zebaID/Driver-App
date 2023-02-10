import 'package:flutter/material.dart';
import '../constants/constants.dart';

class AppTheme {
  const AppTheme._();
  static final lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static ThemeData theme() {
    return ThemeData(
      scaffoldBackgroundColor: kWhiteColor,
      colorScheme: _shrineColorScheme,
      fontFamily: "Muli",
      appBarTheme: appBarTheme(),
      textTheme: textTheme(),
      // inputDecorationTheme: inputDecorationTheme(),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      tabBarTheme: const TabBarTheme(
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                  color: Colors.white) // color for indicator (underline)
              )),
    );
  }

  static final ColorScheme _shrineColorScheme = ColorScheme(
    primary: kPrimaryColor,
    secondary: kPrimaryDarkColor,
    surface: shrineSurfaceWhite,
    background: kWhiteColor,
    error: Colors.red,
    onPrimary: kWhiteColor,
    onSecondary: kWhiteColor,
    onSurface: kBlackColor,
    onBackground: kWhiteColor,
    onError: shrineSurfaceWhite,
    brightness: Brightness.light,
  );

  static Color shrinePink50 = Color(0xFFFEEAE6);
  static Color shrinePink100 = Color(0xFFFEDBD0);
  static Color shrinePink300 = Color(0xFFFBB8AC);
  static Color shrinePink400 = Color(0xFFEAA4A4);
  static Color shrineBrown900 = Color(0xFF442B2D);
  static Color shrineBrown600 = Color(0xFF7D4F52);
  static Color shrineErrorRed = Color(0xFFC5032B);
  static Color shrineSurfaceWhite = Color(0xFFFFFBFA);
  static Color shrineBackgroundWhite = Colors.white;

  static InputDecorationTheme inputDecorationTheme() {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide(color: kTextColor),
      gapPadding: 10,
    );
    return InputDecorationTheme(
      // If  you are using latest version of flutter then lable text and hint text shown like this
      // if you r using flutter less then 1.20.* then maybe this is not working properly
      // if we are define our floatingLabelBehavior in our theme then it's not applayed
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      border: outlineInputBorder,
    );
  }

  static TextTheme textTheme() {
    return const TextTheme(
      bodyText1: TextStyle(color: Colors.black),
      bodyText2: TextStyle(color: Colors.black),
    );
  }

  static AppBarTheme appBarTheme() {
    return const AppBarTheme(
      color: Colors.white,
      elevation: 0,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black),
      textTheme: TextTheme(
        headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
      ),
    );
  }
}
