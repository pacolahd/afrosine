import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({
    required this.onToggle,
    required this.value,
    super.key,
    this.activeColor,
  });
  final bool value;
  final Color? activeColor;
  final ValueChanged<bool?> onToggle;

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      width: 40,
      height: 24,
      toggleSize: 20,
      value: value,
      borderRadius: 30,
      padding: 2,
      activeColor: activeColor ?? context.theme.colors.milkyWhite,
      inactiveColor: Colors.grey,
      activeIcon: Icon(
        Icons.check,
        color: context.theme.colors.dark,
        size: 50,
      ),
      onToggle: onToggle,
    );
  }
}
