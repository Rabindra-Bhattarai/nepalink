import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.green,
    fontFamily: 'OpenSans regular',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: 'OpenSans regular',
        ),
        backgroundColor: Color(0xFFb54747),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    ),
    appBarTheme: AppBarTheme(backgroundColor: Colors.red),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.yellow,
    ),
  );
}
