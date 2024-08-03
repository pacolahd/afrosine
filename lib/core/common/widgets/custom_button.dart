import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.buttonContent,
    required this.onPressed,
    this.height,
    this.buttonColor,
    this.buttonRadius,
    this.width,
    super.key,
  });

  final VoidCallback onPressed;
  final Widget buttonContent;
  // adding ? makes the variable nullable, we'll have default values for these
  final double? buttonRadius;
  final Color? buttonColor;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? context.theme.colors.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: 3,
          vertical: 7,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius ?? 10),
        ),
        minimumSize: Size(
          width ?? double.maxFinite,
          height ?? 50,
        ), // Makes button full width
      ),
      child: buttonContent,
    );
  }
}

class CustomSquareButton extends CustomButton {
  const CustomSquareButton({
    this.textStyle,
    this.labelMargin,
    this.textAlign,
    required this.icon,
    required this.label,
    required super.onPressed,
    this.iconColor,
    this.labelColor,
    this.margin,
    this.padding,
    this.crossAxisAlignment,
    super.buttonContent = const SizedBox(),
    super.height,
    super.width,
    super.buttonColor,
    super.buttonRadius,
    super.key,
  });

  final Widget icon;
  final String label;
  final Color? iconColor;
  final Color? labelColor;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? labelMargin;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment? crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      child: CustomButton(
        width: width,
        height: height,
        buttonColor: buttonColor ?? context.theme.colors.primary,
        buttonRadius: buttonRadius ?? 10,
        buttonContent: Container(
          padding: padding ?? const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(
              //   icon,
              //   color: iconColor ?? context.theme.colors.dark,
              // ),
              icon,
              const SizedBox(height: 10),
              Container(
                margin: labelMargin ?? EdgeInsets.zero,
                child: Text(
                  label,
                  textAlign: textAlign ?? TextAlign.center,
                  style: textStyle ??
                      context.theme.textStyles.bodyBold.copyWith(
                        color: labelColor ??
                            iconColor ??
                            context.theme.colors.dark,
                      ),
                ),
              ),
            ],
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.label,
    required this.icon,
    required this.iconAlignment,
    required this.onPressed,
    this.buttonColor,
    this.buttonRadius,
    super.key,
  });

  final VoidCallback onPressed;
  final Widget label;
  final Widget icon;
  final IconAlignment iconAlignment;
  // adding ? makes the variable nullable, we'll have default values for these
  final double? buttonRadius;
  final Color? buttonColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? context.theme.colors.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: 3,
          vertical: 7,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius ?? 10),
        ),
        minimumSize: const Size(
          double.maxFinite,
          50,
        ), // Makes button full width
      ),
      label: label,
      icon: icon,
      iconAlignment: iconAlignment,
    );
  }
}

class RedCustomIconButton extends CustomIconButton {
  const RedCustomIconButton({
    this.textStyle,
    required super.icon,
    required super.onPressed,
    required this.labelText,
    super.label = const SizedBox(),
    super.iconAlignment = IconAlignment.end,
    super.key,
  });

  final String labelText;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      label: Text(
        labelText,
        style: textStyle ??
            context.theme.textStyles.bodyBold
                .copyWith(color: context.theme.colors.milkyWhite),
      ),
      icon: icon,
      iconAlignment: iconAlignment,
      onPressed: onPressed,
    );
  }
}

class BottomCTA extends StatelessWidget {
  const BottomCTA({
    required this.onRightTextPressed,
    this.left,
    this.right,
    this.leftText,
    this.rightText,
    this.rightTextStyle,
    super.key,
  });

  final Widget? left;
  final Widget? right;
  final String? leftText;
  final String? rightText;
  final TextStyle? rightTextStyle;
  final VoidCallback onRightTextPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        left ??
            Text(
              leftText ?? '',
              style: context.theme.textStyles.body,
            ),
        right ??
            GestureDetector(
              onTap: onRightTextPressed,
              child: Text(
                rightText ?? '',
                style: rightTextStyle ??
                    context.theme.textStyles.body.copyWith(
                      color: context.theme.colors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: context.theme.colors.primary,
                    ),
              ),
            ),
      ],
    );
  }
}

class ButtonWithBottom extends StatelessWidget {
  const ButtonWithBottom({
    required this.bottom,
    required this.button,
    super.key,
  });

  final Widget button;
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        button,
        const SizedBox(
          height: 20,
        ),
        bottom,
      ],
    );
  }
}
