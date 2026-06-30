import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const primary = Color(0xFF7C6CFF);
  static const surface = Color(0xFF252637);
  static const background = Color(0xFF1A1B27);
  static const text = Color(0xFFE0E0F0);
  static const dimText = Color(0xFF9E9EBE);
  static const border = Color(0xFF3D3E58);

  static ThemeData build() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primary,
        surface: surface,
        onSurface: text,
        onPrimary: Colors.white,
        outline: border,
      ),
      scaffoldBackgroundColor: background,
      tabBarTheme: const TabBarThemeData(
        labelColor: primary,
        unselectedLabelColor: dimText,
        indicatorColor: primary,
        dividerColor: Colors.transparent,
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 13),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: background,
        labelStyle: const TextStyle(color: dimText, fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2A2B40)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        isDense: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          side: const BorderSide(color: border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return primary.withAlpha(50);
            return surface;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return primary;
            return dimText;
          }),
          side: WidgetStatePropertyAll(BorderSide(color: border.withAlpha(150))),
        ),
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFF2D2E45)),
      iconTheme: const IconThemeData(color: dimText),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: text, fontSize: 13),
        bodySmall: TextStyle(color: dimText, fontSize: 12),
      ),
    );
  }
}
