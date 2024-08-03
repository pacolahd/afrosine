import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class H2Heading extends StatelessWidget {
  const H2Heading({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Text(
        title,
        style: context.theme.textStyles.h2Bold,
      ),
    );
  }
}

class H3Heading extends StatelessWidget {
  const H3Heading({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Text(
        title,
        style: context.theme.textStyles.h3Bold,
      ),
    );
  }
}

class H3DarkHeading extends StatelessWidget {
  const H3DarkHeading({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Text(
        title,
        style: context.theme.textStyles.h3Bold
            .copyWith(color: context.theme.colorScheme.onSurface),
      ),
    );
  }
}

class H4DarkHeading extends StatelessWidget {
  const H4DarkHeading({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Text(
        title,
        style: context.theme.textStyles.h4Bold
            .copyWith(color: context.theme.colorScheme.onSurface),
      ),
    );
  }
}

class Title1Heading extends StatelessWidget {
  const Title1Heading({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Text(
        title,
        style: context.theme.textStyles.title1Bold.copyWith(
          color: context.theme.colorScheme.secondary,
        ),
      ),
    );
  }
}

class Title2DarkHeading extends StatelessWidget {
  const Title2DarkHeading(
      {required this.title, super.key, this.fontSize, this.maxLines});
  final String title;
  final int? fontSize;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Text(
        title,
        maxLines: maxLines ?? 1,
        overflow: TextOverflow.ellipsis,
        style: context.theme.textStyles.title2Bold.copyWith(
          color: context.theme.colorScheme.onSurface,
          fontSize: fontSize?.toDouble(),
        ),
      ),
    );
  }
}

class Title2Heading extends StatelessWidget {
  const Title2Heading({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Text(
        title,
        style: context.theme.textStyles.title2Bold,
      ),
    );
  }
}

class Title2Text extends StatelessWidget {
  const Title2Text({required this.title, super.key, this.textAlign});
  final String title;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Text(
        title,
        textAlign: textAlign ?? TextAlign.left,
        style: context.theme.textStyles.title2.copyWith(
          color: context.theme.colorScheme.tertiary,
        ),
      ),
    );
  }
}

class BodyBoldHeading extends StatelessWidget {
  const BodyBoldHeading({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Text(
        title,
        style: context.theme.textStyles.bodyBold,
      ),
    );
  }
}

class CaptionBoldTextHeading extends StatelessWidget {
  const CaptionBoldTextHeading({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Text(
        title,
        style: context.theme.textStyles.captionBold
            .copyWith(color: context.theme.colorScheme.tertiary),
      ),
    );
  }
}

class CaptionTextHeading extends StatelessWidget {
  const CaptionTextHeading({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Text(
        title,
        style: context.theme.textStyles.caption
            .copyWith(color: context.theme.colorScheme.tertiary),
      ),
    );
  }
}

class CustomBodyText extends StatelessWidget {
  const CustomBodyText(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Text(
        title,
        style: context.theme.textStyles.body
            .copyWith(color: context.theme.colorScheme.tertiary),
      ),
    );
  }
}

class CaptionText extends StatelessWidget {
  const CaptionText(
    this.title, {
    super.key,
    this.maxLines,
    this.fontSize,
    this.fontWeight,
    this.color,
  });
  final String title;
  final int? maxLines;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Text(
        title,
        style: context.theme.textStyles.caption.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ),
        softWrap: true,
        maxLines: maxLines ?? 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
