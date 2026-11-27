import 'package:flutter/material.dart';

import 'admin_shell.dart';
import 'main_app_page.dart';
import 'admin_dashboard.dart';
import 'admin_management.dart';
import 'found_items.dart';
import 'main_app_page.dart';

class FindyAdminApp extends StatelessWidget {
  const FindyAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: FindyColors.primary,
      brightness: Brightness.dark,
    ).copyWith(
      primary: FindyColors.primary,
      onPrimary: Colors.white,
      secondary: FindyColors.accent,
      surface: FindyColors.bg,
    );

    return MaterialApp(
      title: 'Findy Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: FindyColors.bg,
        appBarTheme: const AppBarTheme(
          backgroundColor: FindyColors.bg,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        navigationRailTheme: const NavigationRailThemeData(
          backgroundColor: FindyColors.bg,
          indicatorColor: FindyColors.primary,
        ),
        navigationDrawerTheme: const NavigationDrawerThemeData(
          backgroundColor: FindyColors.bg,
          indicatorColor: FindyColors.primary,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const AdminShell(),
    );
  }
}
