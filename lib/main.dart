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
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.main,
        primary: AppColors.main,
        outline: AppColors.lightGray,
      ),
      dividerColor: AppColors.lightGray,
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
      inputDecorationTheme: const InputDecorationTheme(
        outlineBorder: BorderSide(color: AppColors.main),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.main),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return AppColors.lightGray;
            } else {
              return AppColors.main;
            }
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return AppColors.grey;
            } else {
              return AppColors.white;
            }
          }),
          overlayColor: MaterialStateProperty.resolveWith((states) {
            return states.contains(MaterialState.pressed)
                ? AppColors.deepMain
                : null;
          }),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          )),
        ),
      ),
    );
  }
}

class AppColors {
  static const main = Color(0xFF5CB85D);
  static const deepMain = Color(0xFF377038);
  static const important = Color(0xFFDC3A40);
  static const white = Color(0xFFFFFFFF);
  static const grey = Colors.grey;
  static const lightGray = Color(0xFFCCCCCC);
  static const darkGrey = Color(0xFF333333);
}
