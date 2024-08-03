import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    required this.value,
    required this.onChanged,
    super.key,
  });
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    // const selectedIcon = Icon(Icons.check_box);
    // const unSelectedIcon = Icon(Icons.check_box_outline_blank);;

    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Icon(
        value ? Icons.check_box : Icons.check_box_outline_blank,
        size: 24,
      ),
    );
  }
}
