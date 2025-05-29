import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() {
    const seedColor = Colors.red;

    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: seedColor,
      fontFamily: 'Roboto',

      listTileTheme: const ListTileThemeData(iconColor: seedColor),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black87),
        headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
        titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w300, color: Colors.white),
      ),
    );
  }
}
