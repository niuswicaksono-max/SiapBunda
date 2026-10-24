import 'package:flutter/material.dart';

const Color kInk = Color(0xFF2A2140);
const Color kPlum = Color(0xFF3B2A63);
const Color kCoral = Color(0xFFF28C7C);
const Color kLilac = Color(0xFFE6DAF3);
const Color kPaper = Color(0xFFFBF8FE);

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: kPlum,
    brightness: Brightness.light,
  ).copyWith(primary: kPlum, secondary: kCoral, surface: kPaper);

  OutlineInputBorder border(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: kPaper,
    textTheme: Typography.blackMountainView.apply(
      bodyColor: kInk,
      displayColor: kInk,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: border(kLilac),
      border: border(kLilac),
      focusedBorder: border(kPlum, 2),
      errorBorder: border(const Color(0xFFC0392B)),
      focusedErrorBorder: border(const Color(0xFFC0392B), 2),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: kPlum,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kPlum,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );
}
