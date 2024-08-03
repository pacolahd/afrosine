import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class IField extends StatelessWidget {
  const IField({
    required this.label,
    required this.controller,
    this.filled = false,
    this.obscureText = false,
    this.readOnly = false,
    super.key,
    this.validator,
    this.fillColour,
    this.suffixIcon,
    this.hintText,
    this.keyboardType,
    this.hintStyle,
    this.overrideValidator = false,
    this.onTap,
    this.focusNode,
  });

  final String label;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final bool filled;
  final Color? fillColour;
  final bool obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool overrideValidator;
  final TextStyle? hintStyle;
  final VoidCallback? onTap;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.theme.textStyles.bodyBold),
        const SizedBox(height: 8),
        TextFormField(
          style: context.theme.textStyles.body.copyWith(
            color: context.theme.colors.dark,
          ),
          focusNode: focusNode,
          onTap: onTap,
          controller: controller,
          validator: overrideValidator
              ? validator
              : (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return validator?.call(value);
                },
          onTapOutside: (_) {
            FocusScope.of(context).unfocus();
          },
          keyboardType: keyboardType,
          obscureText: obscureText,
          readOnly: readOnly,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: context.theme.colors.milkyWhite),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide:
                  BorderSide(color: context.theme.colorScheme.onPrimary),
            ),

            // overwriting the default padding helps with that puffy look of the textfield
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            filled: filled,
            fillColor: fillColour,
            suffixIcon: suffixIcon,
            hintText: hintText,
            hintStyle: hintStyle ??
                const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ),
      ],
    );
  }
}
