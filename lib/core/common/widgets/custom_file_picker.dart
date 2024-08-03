import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class CustomFilePicker extends StatelessWidget {
  const CustomFilePicker({
    required this.label,
    required this.iconName,
    required this.onPressed,
    super.key,
  });
  final String label;
  final String iconName;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: context.theme.colorScheme.tertiaryFixed,
          ),
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                width: 30,
                height: 30,
                child: Image.asset(
                  iconName,
                  color: context.theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  label,
                  style: context.theme.textStyles.title2
                      .copyWith(color: context.theme.colorScheme.secondary),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
