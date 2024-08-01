import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  colorScheme: const ColorScheme.light(
    // color for big container
    surface: Colors.white,

    // color for drop down button
    primary: Color.fromRGBO(245, 245, 245, 1),

    //  color for choose device
    secondary: Colors.white,

    // color for background
    onSurface: Color.fromRGBO(245, 245, 245, 1),
  ),
  textTheme: const TextTheme(
    // color for text
    bodyLarge: TextStyle(color: Colors.black),

    bodyMedium: TextStyle(color: Colors.black),
  ),
  iconTheme: const IconThemeData(color: Colors.black),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey.shade800,
  colorScheme: const ColorScheme.dark(
    // color for big container
    surface: Color.fromRGBO(37, 37, 37, 1),

    // color for button drop down
    primary: Color.fromRGBO(60, 60, 60, 1),

    // color for icon in drop down menu
    secondary: Color.fromRGBO(60, 60, 60, 1),

    // color for background
    onSurface: Color.fromRGBO(24, 24, 24, 1),
  ),

  // color for text
  textTheme: const TextTheme(
    // color for text
    bodyLarge: TextStyle(
      color: Color.fromRGBO(237, 238, 239, 1),
    ),
    bodyMedium: TextStyle(color: Colors.white),
  ),

  // color for icon
  iconTheme: const IconThemeData(color: Colors.white),
);
