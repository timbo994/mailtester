import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'ui/main_window.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(1200, 740),
    minimumSize: Size(800, 600),
    center: true,
    title: 'SMTP & Exchange OAuth Tester',
    backgroundColor: Color(0xFF1A1B27),
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const ProviderScope(child: _App()));
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMTP & Exchange OAuth Tester',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const MainWindow(),
    );
  }

  ThemeData _buildTheme() {
    const primary = Color(0xFF7C6CFF);
    const surface = Color(0xFF252637);
    const bg = Color(0xFF1A1B27);
    const text = Color(0xFFE0E0F0);
    const dimText = Color(0xFF9E9EBE);

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primary,
        surface: surface,
        onSurface: text,
        onPrimary: Colors.white,
        outline: const Color(0xFF3D3E58),
      ),
      scaffoldBackgroundColor: bg,
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
        fillColor: bg,
        labelStyle: const TextStyle(color: dimText, fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF3D3E58)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF3D3E58)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2A2B40)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        isDense: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          side: const BorderSide(color: Color(0xFF3D3E58)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primary.withAlpha(50);
            }
            return surface;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return primary;
            return dimText;
          }),
          side: WidgetStatePropertyAll(
            BorderSide(color: const Color(0xFF3D3E58).withAlpha(150)),
          ),
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
