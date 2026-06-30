import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const primary = Color(0xFF7C6CFF);
  static const surface = Color(0xFF252637);
  static const background = Color(0xFF1A1B27);
  static const text = Color(0xFFE0E0F0);
  static const dimText = Color(0xFF9E9EBE);
  static const border = Color(0xFF3D3E58);
  static const cardBorder = Color(0xFF2D2E45);
  static const disabledBorder = Color(0xFF2A2B40);

  static const subtleText = Color(0xFF9E9E9E);
  static const mutedText = Color(0xFF7070A0);
  static const hintText = Color(0xFF555570);
  static const deepHint = Color(0xFF444460);
  static const autoBadgeText = Color(0xFF9090E0);

  static const panelBackground = Color(0xFF141520);
  static const appBarBackground = Color(0xFF1E1F30);
  static const panelHeaderText = Color(0xFFB0B0C8);

  static const statusIdle = Color(0xFF9E9E9E);
  static const statusConnecting = Color(0xFFFF9800);
  static const statusConnected = Color(0xFF4CAF50);
  static const statusError = Color(0xFFF44336);

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
          borderSide: const BorderSide(color: disabledBorder),
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
      dividerTheme: const DividerThemeData(color: cardBorder),
      iconTheme: const IconThemeData(color: dimText),
      textTheme: const TextTheme(
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text),
        bodyMedium: TextStyle(color: text, fontSize: 13),
        bodySmall: TextStyle(color: dimText, fontSize: 12),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: mutedText,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
