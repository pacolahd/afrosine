import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class CustomListTile2 extends StatelessWidget {
  const CustomListTile2({
    required this.title,
    required this.value,
    required this.onPressed,
    this.leadingIconUrl,
    this.trailingIconUrl,
    super.key,
    this.leadingIcon,
    this.trailingIcon,
  });
  final String title;
  final bool value;
  final String? leadingIconUrl;
  final String? trailingIconUrl;
  final VoidCallback onPressed;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: GestureDetector(
        onTap: onPressed,
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
            Icon(
              trailingIcon ?? Icons.arrow_forward,
              color: context.theme.colorScheme.tertiary,
            ),
            // Image.asset(
            //   trailingIconUrl ?? MediaRes.arrowRight2,
            //   color: context.theme.colorScheme.tertiary,
            // ),
          ],
        ),
      ),
    );
  }
}
