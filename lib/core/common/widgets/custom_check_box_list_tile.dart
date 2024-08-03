import 'package:afrosine/core/common/widgets/custom_check_box.dart';
import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class CustomCheckboxListTile extends StatelessWidget {
  const CustomCheckboxListTile({
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
  });
  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: context.theme.textStyles.body
                  .copyWith(color: context.theme.colorScheme.tertiary),
            ),
          ),
          CustomCheckbox(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
