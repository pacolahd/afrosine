import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomFormBuilderTextField extends StatelessWidget {
  const CustomFormBuilderTextField({
    required this.name,
    this.border,
    this.controller,
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
    this.enabled,
    this.maxLines = 1,
  });

  final String name;
  final bool? enabled;
  final InputBorder? border;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
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
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      enabled: enabled ?? true,
      name: name,
      style: context.theme.textStyles.body.copyWith(
        color: context.theme.colors.dark,
      ),
      focusNode: focusNode,
      controller: controller,
      onTap: onTap,
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
      maxLines: maxLines,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      decoration: InputDecoration(
        border: border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
        enabledBorder: border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: context.theme.colors.milkyWhite),
            ),
        focusedBorder: border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
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
    );
  }
}
