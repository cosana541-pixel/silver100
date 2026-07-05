import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/tutorial_screen.dart';
import 'state/app_settings_store.dart';

class Silver100App extends StatefulWidget {
  const Silver100App({super.key});

  @override
  State<Silver100App> createState() => _Silver100AppState();
}

class _Silver100AppState extends State<Silver100App> {
  bool _tutorialDone = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appSettingsStore,
      builder: (context, _) {
        final scale = appSettingsStore.textScale;

        return MaterialApp(
          title: '실버100',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1F7A5A),
              primary: const Color(0xFF1F7A5A),
              secondary: const Color(0xFFD58A1F),
              tertiary: const Color(0xFF4066A5),
              surface: const Color(0xFFF8F6EF),
            ),
            scaffoldBackgroundColor: const Color(0xFFF8F6EF),
            fontFamily: 'Roboto',
            textTheme: TextTheme(
              displaySmall: TextStyle(
                fontSize: 36 * scale,
                fontWeight: FontWeight.w800,
              ),
              headlineMedium: TextStyle(
                fontSize: 30 * scale,
                fontWeight: FontWeight.w800,
              ),
              headlineSmall: TextStyle(
                fontSize: 30 * scale,
                fontWeight: FontWeight.w800,
              ),
              titleLarge: TextStyle(
                fontSize: 30 * scale,
                fontWeight: FontWeight.w800,
              ),
              bodyLarge: TextStyle(fontSize: 22 * scale, height: 1.35),
              bodyMedium: TextStyle(fontSize: 22 * scale, height: 1.35),
              labelLarge: TextStyle(
                fontSize: 22 * scale,
                fontWeight: FontWeight.w800,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(68),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          home: _tutorialDone
              ? const HomeScreen()
              : TutorialScreen(
                  onDone: () => setState(() => _tutorialDone = true),
                ),
        );
      },
    );
  }
}
