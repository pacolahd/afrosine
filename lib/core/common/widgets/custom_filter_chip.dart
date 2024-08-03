import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class CustomFilterChip extends StatelessWidget {
  const CustomFilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
    super.key,
  });
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      showCheckmark: false,
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: context.theme.colorScheme.primary,
      backgroundColor: context.theme.colorScheme.surface,
      labelStyle: context.theme.textStyles.body.copyWith(
        color: isSelected
            ? context.theme.colors.primary
            : context.theme.colorScheme.tertiaryContainer,
      ),
      shape: StadiumBorder(
        side: BorderSide(
          width: 0.5,
          color: isSelected
              ? context.theme.colors.primary
              : context.theme.colors.milkyWhite,
        ),
      ),
    );
  }
}
