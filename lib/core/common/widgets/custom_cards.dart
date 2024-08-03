import 'package:afrosine/core/common/widgets/custom_button.dart';
import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class CardWithBottomPointer extends CustomSquareButton {
  const CardWithBottomPointer({
    required super.label,
    required super.icon,
    required super.onPressed,
    this.selected = true,
    super.key,
  });
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSquareButton(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          buttonRadius: 20,
          height: 144,
          icon: icon,
          iconColor: selected
              ? context.theme.colors.primary
              : context.theme.colorScheme.tertiary,
          buttonColor: selected
              ? context.theme.colors.primary
              : context.theme.colorScheme.onTertiary,
          label: label,
          labelMargin: const EdgeInsets.symmetric(horizontal: 2),
          onPressed: onPressed,
        ),
        const SizedBox(
          height: 10,
        ),
        if (selected)
          Container(
            width: 60,
            height: 6,
            decoration: BoxDecoration(
              color: context.theme.colors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
          )
        else
          const SizedBox(),
      ],
    );
  }
}

// class ItemSelectionCard extends CustomSquareButton {
//   const ItemSelectionCard({
//     required super.label,
//     required super.icon,
//     required super.onPressed,
//     this.selected = true,
//     super.key,
//   });
//   final bool selected;
//   @override
//   Widget build(BuildContext context) {
//     return CustomSquareButton(
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       height: 105,
//       icon: icon,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       iconColor: selected
//           ? context.theme.colors.background
//           : context.theme.colorScheme.tertiary,
//       buttonColor: selected
//           ? context.theme.colors.primary
//           : context.theme.colorScheme.onTertiary,
//       label: label,
//       textAlign: TextAlign.left,
//       onPressed: onPressed,
//       padding: EdgeInsets.zero,
//     );
//   }
// }

class ItemSelectionCard extends StatelessWidget {
  const ItemSelectionCard({
    required this.label,
    required this.onPressed,
    this.iconName,
    this.height,
    this.buttonColor,
    this.buttonRadius,
    this.width,
    super.key,
    this.selected = false,
  });

  final VoidCallback onPressed;
  final String label;
  // adding ? makes the variable nullable, we'll have default values for these
  final double? buttonRadius;
  final Color? buttonColor;
  final double? height;
  final double? width;
  final bool selected;
  final String? iconName;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: selected
            ? context.theme.colors.primary
            : context.theme.colorScheme.surface,
        padding: const EdgeInsets.symmetric(
          horizontal: 3,
          vertical: 7,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.5,
            color: selected
                ? context.theme.colors.primary
                : context.theme.colors.milkyWhite,
          ),
          borderRadius: BorderRadius.circular(buttonRadius ?? 10),
        ),
        minimumSize: Size(
          width ?? double.maxFinite,
          height ?? 105,
        ), // Makes button full width
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: width ?? double.maxFinite,
        child: Column(
          crossAxisAlignment: iconName == null
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            if (iconName != null)
              Image.asset(
                iconName!,
                color: selected
                    ? context.theme.colors.primary
                    : context.theme.colorScheme.tertiaryContainer,
              ),
            SizedBox(
              height: iconName != null ? 15 : 0,
            ),
            Text(
              label,
              style: context.theme.textStyles.title2Bold.copyWith(
                color: selected
                    ? context.theme.colors.primary
                    : context.theme.colorScheme.tertiaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
