import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/presentation/navigation/app_navigation.dart';

void main() {
  runApp(const ProviderScope(child: RealWorldApp()));
}

class RealWorldApp extends ConsumerWidget {
  const RealWorldApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'RealWorld',
      theme: _themeData(),
      routerConfig: ref.watch(AppNavigation.provider).router,
    );
  }

  ThemeData _themeData() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.main,
      dividerColor: AppColors.lightGray,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.main,
        titleTextStyle: GoogleFonts.titilliumWeb(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      tabBarTheme: const TabBarTheme(
        indicatorColor: AppColors.main,
        labelColor: AppColors.main,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.main,
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
  static const lightGray = Color(0xFFCCCCCC);
  static const grey = Colors.grey;
}
