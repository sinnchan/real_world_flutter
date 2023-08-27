import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/presentation/ui/page/main/main_page.dart';

void main() {
  runApp(const ProviderScope(child: RealWorldApp()));
}

class RealWorldApp extends StatelessWidget {
  const RealWorldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RealWorld',
      theme: _themeData(),
      home: const MainPage(),
    );
  }

  ThemeData _themeData() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.main,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.main,
        titleTextStyle: GoogleFonts.titilliumWeb(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.main,
        foregroundColor: AppColors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.main,
      ),
    );
  }
}

class AppColors {
  static const main = Color(0xFF5CB85D);
  static const white = Color(0xFFFFFFFF);
}
