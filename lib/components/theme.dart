import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  colorScheme: const ColorScheme.light(
    // color for big container
    surface: Colors.white,

    // color for drop down button
    primary: Color.fromRGBO(245, 245, 245, 1),

    //  color for icon in drop down menu
    secondary: Colors.grey,

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
    surface:  Color.fromRGBO(22, 28, 44, 1),

    // color for button drop down
    primary:  Color.fromRGBO(5, 12, 21, 1),

    // color for icon in drop down menu
    secondary:  Color.fromRGBO(237, 238, 239, 1),

    // color for background
    onSurface:  Color.fromRGBO(9, 13, 25, 1),
  ),
  textTheme: const TextTheme(
    // color for text
    bodyLarge: TextStyle(
      color: Color.fromRGBO(237, 238, 239, 1),
    ),
    bodyMedium: TextStyle(color: Colors.white),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
);
