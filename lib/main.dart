import 'package:flutter/material.dart';
import 'package:food_delivery_resto_app/presentation/auth/pages/splash_pages.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/constants/colors.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.white,
        dividerTheme: const DividerThemeData(color: AppColors.divider),
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: AppBarTheme(
          color: AppColors.primary,
          elevation: 0,
          titleTextStyle: GoogleFonts.inter(
            color: AppColors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
          iconTheme: const IconThemeData(
            color: AppColors.white,
          ),
          centerTitle: true,
        ),
      ),
      home: const SplashPages(),
    );
  }
}

