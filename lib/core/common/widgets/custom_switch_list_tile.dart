import 'package:afrosine/core/common/widgets/custom_switch.dart';
import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class CustomSwitchListTile extends StatelessWidget {
  const CustomSwitchListTile({
    required this.title,
    required this.value,
    required this.onChanged,
    this.leadingIconUrl,
    super.key,
  });
  final String title;
  final bool value;
  final String? leadingIconUrl;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          if (leadingIconUrl != null)
            Image.asset(
              leadingIconUrl!,
              color: context.theme.colorScheme.tertiary,
            ),
          if (leadingIconUrl != null) const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: context.theme.textStyles.body.copyWith(),
            ),
          ),
          CustomSwitch(onToggle: onChanged, value: value)
        ],
      ),
    );
  }
}
