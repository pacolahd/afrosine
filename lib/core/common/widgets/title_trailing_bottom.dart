import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:afrosine/core/resources/theme/app_theme_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleTrailingBottom extends StatelessWidget {
  const TitleTrailingBottom({
    required this.title,
    required this.bottom,
    required this.onTrailingPressed,
    this.trailingText,
    this.spacing,
    super.key,
  });
  final String title;
  final String? trailingText;
  final double? spacing;
  final VoidCallback onTrailingPressed;

  final Widget bottom;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: context.theme.textStyles.title1Bold.copyWith(
                color: context.theme.colorScheme.secondary,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: onTrailingPressed,
              child: Text(
                trailingText ?? 'See All',
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 21.0.toFigmaHeight(fontSize: 15),
                  color: context.theme.colorScheme.secondary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: spacing ?? 0),
        bottom,
      ],
    );
  }
}
