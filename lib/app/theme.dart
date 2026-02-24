import 'package:flutter/material.dart';

/// Global Material theme used by the application.
final appTheme = ThemeData(
  useMaterial3: true,
  brightness: .dark,
  colorSchemeSeed: Colors.deepPurple,
  fontFamily: 'Manrope',
  textTheme: const .new(
    displayMedium: .new(
      fontSize: 36,
      fontWeight: FontWeight.w800,
    ),
    displaySmall: .new(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
  ),
);
