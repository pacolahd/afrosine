import 'package:afrosine/core/common/widgets/custom_form_builder_text_field.dart';
import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CustomFormBuilderTitledTextField extends StatelessWidget {
  const CustomFormBuilderTitledTextField({
    required this.title,
    required this.name,
    this.required = true,
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

  final bool? required;
  final String title;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            RichText(
              text: TextSpan(
                text: title,
                style: context.theme.textStyles.bodyBold.copyWith(
                  color: context.theme.colors.dark,
                ),
                children: !required!
                    ? null
                    : [
                        TextSpan(
                          text: ' *',
                          style: context.theme.textStyles.body.copyWith(
                            color: context.theme.colorScheme.primary,
                          ),
                        ),
                      ],
              ),
            ),
            if (suffixIcon != null) suffixIcon!,
          ],
        ),
        const SizedBox(height: 8),
        CustomFormBuilderTextField(
          maxLines: maxLines,
          name: name,
          hintText: hintText ?? 'Enter $title',
          // hintStyle: hintStyle,
          overrideValidator: true,
          validator: required == true
              ? FormBuilderValidators.required(errorText: '$title is required')
              : null,
        ),
      ],
    );
  }
}
