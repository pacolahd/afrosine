import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

extension FigmaDimention on double {
  double toFigmaHeight({required double fontSize}) {
    return this / fontSize;
  }
}

class AppTextTheme extends ThemeExtension<AppTextTheme> {
  AppTextTheme({
    required this.h1,
    required this.h1Bold,
    required this.h2,
    required this.h2Bold,
    required this.h3,
    required this.h3Bold,
    required this.h4,
    required this.h4Bold,
    required this.h5,
    required this.h5Bold,
    required this.title1,
    required this.title1Bold,
    required this.title2,
    required this.title2Bold,
    required this.body,
    required this.bodyBold,
    required this.bodyUnderline,
    required this.caption,
    required this.captionBold,
    required this.captionUnderline,
  });
  final TextStyle h1;
  final TextStyle h1Bold;
  final TextStyle h2;
  final TextStyle h2Bold;
  final TextStyle h3;
  final TextStyle h3Bold;
  final TextStyle h4;
  final TextStyle h4Bold;
  final TextStyle h5;
  final TextStyle h5Bold;
  final TextStyle title1;
  final TextStyle title1Bold;
  final TextStyle title2;
  final TextStyle title2Bold;
  final TextStyle body;
  final TextStyle bodyBold;
  final TextStyle bodyUnderline;
  final TextStyle caption;
  final TextStyle captionBold;
  final TextStyle captionUnderline;

  @override
  AppTextTheme copyWith({
    TextStyle? h1,
    TextStyle? h1Bold,
    TextStyle? h2,
    TextStyle? h2Bold,
    TextStyle? h3,
    TextStyle? h3Bold,
    TextStyle? h4,
    TextStyle? h4Bold,
    TextStyle? h5,
    TextStyle? h5Bold,
    TextStyle? title1,
    TextStyle? title1Bold,
    TextStyle? title2,
    TextStyle? title2Bold,
    TextStyle? body,
    TextStyle? bodyBold,
    TextStyle? bodyUnderline,
    TextStyle? caption,
    TextStyle? captionBold,
    TextStyle? captionUnderline,
  }) {
    return AppTextTheme(
      h1: h1 ?? this.h1,
      h1Bold: h1Bold ?? this.h1Bold,
      h2: h2 ?? this.h2,
      h2Bold: h2Bold ?? this.h2Bold,
      h3: h3 ?? this.h3,
      h3Bold: h3Bold ?? this.h3Bold,
      h4: h4 ?? this.h4,
      h4Bold: h4Bold ?? this.h4Bold,
      h5: this.h5,
      h5Bold: this.h5Bold,
      title1: title1 ?? this.title1,
      title1Bold: title1Bold ?? this.title1Bold,
      title2: title2 ?? this.title2,
      title2Bold: title2Bold ?? this.title2Bold,
      body: body ?? this.body,
      bodyBold: bodyBold ?? this.bodyBold,
      bodyUnderline: bodyUnderline ?? this.bodyUnderline,
      caption: caption ?? this.caption,
      captionBold: captionBold ?? this.captionBold,
      captionUnderline: captionUnderline ?? this.captionUnderline,
    );
  }

  @override
  AppTextTheme lerp(ThemeExtension<AppTextTheme>? other, double t) {
    if (other is! AppTextTheme) return this;
    return AppTextTheme(
      h1: TextStyle.lerp(h1, other.h1, t)!,
      h1Bold: TextStyle.lerp(h1Bold, other.h1Bold, t)!,
      h2: TextStyle.lerp(h2, other.h2, t)!,
      h2Bold: TextStyle.lerp(h2Bold, other.h2Bold, t)!,
      h3: TextStyle.lerp(h3, other.h3, t)!,
      h3Bold: TextStyle.lerp(h3Bold, other.h3Bold, t)!,
      h4: TextStyle.lerp(h4, other.h4, t)!,
      h4Bold: TextStyle.lerp(h4Bold, other.h4Bold, t)!,
      h5: TextStyle.lerp(h5, other.h5, t)!,
      h5Bold: TextStyle.lerp(h5Bold, other.h5Bold, t)!,
      title1: TextStyle.lerp(title1, other.title1, t)!,
      title1Bold: TextStyle.lerp(title1Bold, other.title1Bold, t)!,
      title2: TextStyle.lerp(title2, other.title2, t)!,
      title2Bold: TextStyle.lerp(title2Bold, other.title2Bold, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      bodyBold: TextStyle.lerp(bodyBold, other.bodyBold, t)!,
      bodyUnderline: TextStyle.lerp(bodyUnderline, other.bodyUnderline, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      captionBold: TextStyle.lerp(captionBold, other.captionBold, t)!,
      captionUnderline:
          TextStyle.lerp(captionUnderline, other.captionUnderline, t)!,
    );
  }
}

final AppTextTheme baseTextStyles = AppTextTheme(
  h1: GoogleFonts.poppins(
    fontSize: 48,
    fontWeight: FontWeight.w400,
    letterSpacing: -1.5,
    height: 67.2.toFigmaHeight(fontSize: 48),
    color: AppColors.dark,
  ),
  h1Bold: GoogleFonts.poppins(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
    height: 67.2.toFigmaHeight(fontSize: 48),
    color: AppColors.dark,
  ),
  h2: GoogleFonts.poppins(
    fontSize: 40,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.5,
    height: 56.0.toFigmaHeight(fontSize: 40),
    color: AppColors.dark,
  ),
  h2Bold: GoogleFonts.poppins(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 56.0.toFigmaHeight(fontSize: 40),
    color: AppColors.dark,
  ),
  h3: GoogleFonts.poppins(
    fontSize: 33,
    fontWeight: FontWeight.w400,
    height: 46.2.toFigmaHeight(fontSize: 33),
    color: AppColors.dark,
  ),
  h3Bold: GoogleFonts.poppins(
    fontSize: 33,
    fontWeight: FontWeight.w700,
    height: 46.2.toFigmaHeight(fontSize: 33),
    color: AppColors.dark,
  ),
  h4: GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 39.2.toFigmaHeight(fontSize: 28),
    color: AppColors.dark,
  ),
  h4Bold: GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.25,
    height: 39.2.toFigmaHeight(fontSize: 28),
    color: AppColors.dark,
  ),
  h5: GoogleFonts.poppins(
    fontSize: 76,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 106.4.toFigmaHeight(fontSize: 76),
    color: AppColors.dark,
  ),
  h5Bold: GoogleFonts.poppins(
    fontSize: 76,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 106.4.toFigmaHeight(fontSize: 76),
    color: AppColors.dark,
  ),
  title1: GoogleFonts.poppins(
    fontSize: 23,
    fontWeight: FontWeight.w400,
    height: 32.2.toFigmaHeight(fontSize: 23),
    color: AppColors.dark,
  ),
  title1Bold: GoogleFonts.poppins(
    fontSize: 23,
    fontWeight: FontWeight.w700,
    height: 32.2.toFigmaHeight(fontSize: 23),
    color: AppColors.dark,
  ),
  title2: GoogleFonts.poppins(
    fontSize: 19,
    fontWeight: FontWeight.w400,
    height: 26.6.toFigmaHeight(fontSize: 19),
    color: AppColors.dark,
  ),
  title2Bold: GoogleFonts.poppins(
    fontSize: 19,
    fontWeight: FontWeight.w700,
    height: 26.6.toFigmaHeight(fontSize: 19),
    color: AppColors.dark,
  ),
  body: GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 22.4.toFigmaHeight(fontSize: 16),
    color: AppColors.dark,
  ),
  bodyBold: GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 22.4.toFigmaHeight(fontSize: 16),
    color: AppColors.dark,
  ),
  bodyUnderline: GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 22.4.toFigmaHeight(fontSize: 16),
    color: AppColors.dark,
    decoration: TextDecoration.underline,
  ),
  caption: GoogleFonts.roboto(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 18.2.toFigmaHeight(fontSize: 13),
    color: AppColors.dark,
  ),
  captionBold: GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    height: 18.2.toFigmaHeight(fontSize: 13),
    color: AppColors.dark,
  ),
  captionUnderline: GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.dark,
    height: 18.2.toFigmaHeight(fontSize: 13),
    decoration: TextDecoration.underline,
  ),
);
