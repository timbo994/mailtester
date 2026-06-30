import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'ui/app_theme.dart';
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
      theme: AppTheme.build(),
      home: const MainWindow(),
    );
  }
}
