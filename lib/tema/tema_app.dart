import 'package:flutter/material.dart';

class TemaApp {
  static ThemeData get claro {
    final cores = ColorScheme.fromSeed(
      seedColor: const Color(0xFF4F46E5),
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: cores,
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }
}
