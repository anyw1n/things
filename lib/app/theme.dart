import 'package:flutter/material.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorSchemeSeed: Colors.deepPurple,
  fontFamily: 'Manrope',
  textTheme: const TextTheme(
    displayMedium: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w800,
    ),
    displaySmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
  ),
);
