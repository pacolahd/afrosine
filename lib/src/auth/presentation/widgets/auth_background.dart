import 'dart:ui';

import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({
    required this.image,
    required this.child,
    required this.margin,
    super.key,
  });
  final String image;
  final Widget child;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
          // colorFilter: ColorFilter.mode(
          //   Colors.black.withOpacity(0.5),
          //   BlendMode.darken,
          // ),
        ),
      ),
      child: SafeArea(
        child: Container(
          margin: margin,
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surfaceDim.withOpacity(.3),
            border: Border.all(
              width: 1,
              color: context.theme.colorScheme.onSecondary,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Center(
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
