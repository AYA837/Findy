import 'package:flutter/material.dart';

import 'community_home.dart';

import 'community_shell.dart';

class FindyCommunityApp extends StatelessWidget {
  const FindyCommunityApp({super.key});

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
      title: 'Findy Community',
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
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const CommunityShell(),
    );
  }
}
