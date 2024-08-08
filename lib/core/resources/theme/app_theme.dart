import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_theme_theme.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: GoogleFonts.poppins().fontFamily,
    primaryColor: AppColors.orange,
    scaffoldBackgroundColor: AppColors.milkyWhite,
    appBarTheme: const AppBarTheme(
      color: AppColors.milkyWhite,
      iconTheme: IconThemeData(color: AppColors.dark),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.orange,
      onPrimary: AppColors.white,
      secondary: AppColors.dark,
      onSecondary: AppColors.milkyWhite,
      error: AppColors.orange,
      onError: AppColors.white,
      background: AppColors.milkyWhite,
      onBackground: AppColors.dark,
      surface: AppColors.white,
      onSurface: AppColors.dark,
    ),
    extensions: [baseTextStyles],
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.orange,
      unselectedItemColor: AppColors.dark,
      selectedLabelStyle: baseTextStyles.caption.copyWith(
        color: AppColors.orange,
      ),
      unselectedLabelStyle: baseTextStyles.caption.copyWith(
        color: AppColors.dark,
        fontSize: 11,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: GoogleFonts.poppins().fontFamily,
    primaryColor: AppColors.orange,
    scaffoldBackgroundColor: const Color(0xFF121212), // Dark gray background
    appBarTheme: const AppBarTheme(
      color: Color(0xFF1E1E1E), // Slightly lighter than background
      iconTheme: IconThemeData(color: Color(0xFFE0E0E0)), // Light gray icons
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.orange,
      onPrimary: Color(0xFF121212), // Dark text on orange
      secondary: Color(0xFF3D3D3D), // Dark gray for secondary elements
      onSecondary: Color(0xFFE0E0E0), // Light gray text on secondary
      error: Color(0xFFCF6679), // Material design dark theme error color
      onError: Color(0xFF121212), // Dark text on error
      background: Color(0xFF121212), // Dark gray background
      onBackground: Color(0xFFE0E0E0), // Light gray text on background
      surface:
          Color(0xFF1E1E1E), // Slightly lighter than background for surfaces
      onSurface: Color(0xFFE0E0E0), // Light gray text on surfaces
    ),
    extensions: [
      baseTextStyles.copyWith(
        h1: baseTextStyles.h1.copyWith(color: const Color(0xFFE0E0E0)),
        h1Bold: baseTextStyles.h1Bold.copyWith(color: const Color(0xFFE0E0E0)),
        h2: baseTextStyles.h2.copyWith(color: const Color(0xFFE0E0E0)),
        h2Bold: baseTextStyles.h2Bold.copyWith(color: const Color(0xFFE0E0E0)),
        h3: baseTextStyles.h3.copyWith(color: const Color(0xFFE0E0E0)),
        h3Bold: baseTextStyles.h3Bold.copyWith(color: const Color(0xFFE0E0E0)),
        h4: baseTextStyles.h4.copyWith(color: const Color(0xFFE0E0E0)),
        h4Bold: baseTextStyles.h4Bold.copyWith(color: const Color(0xFFE0E0E0)),
        title1: baseTextStyles.title1.copyWith(color: const Color(0xFFE0E0E0)),
        title1Bold:
            baseTextStyles.title1Bold.copyWith(color: const Color(0xFFE0E0E0)),
        title2: baseTextStyles.title2.copyWith(color: const Color(0xFFE0E0E0)),
        title2Bold:
            baseTextStyles.title2Bold.copyWith(color: const Color(0xFFE0E0E0)),
        body: baseTextStyles.body.copyWith(color: const Color(0xFFE0E0E0)),
        bodyBold:
            baseTextStyles.bodyBold.copyWith(color: const Color(0xFFE0E0E0)),
        bodyUnderline: baseTextStyles.bodyUnderline
            .copyWith(color: const Color(0xFFE0E0E0)),
        caption: baseTextStyles.caption.copyWith(
            color: const Color(0xFFB0B0B0)), // Slightly dimmer for captions
        captionBold:
            baseTextStyles.captionBold.copyWith(color: const Color(0xFFB0B0B0)),
        captionUnderline: baseTextStyles.captionUnderline
            .copyWith(color: const Color(0xFFB0B0B0)),
      ),
    ],
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.dark, // Slightly lighter than background
      selectedItemColor: AppColors.orange,
      unselectedItemColor:
          const Color(0xFFB0B0B0), // Dimmer color for unselected items
      selectedLabelStyle: baseTextStyles.caption.copyWith(
        color: AppColors.orange,
      ),
      unselectedLabelStyle: baseTextStyles.caption.copyWith(
        color: AppColors.dark,
        fontSize: 11,
      ),
    ),
  );
}
