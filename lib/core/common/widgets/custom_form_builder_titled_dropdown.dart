import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:iconly/iconly.dart';

class CustomFormBuilderTitledDropdown extends StatelessWidget {
  const CustomFormBuilderTitledDropdown(
      {required this.title,
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
      required this.options,
      this.initialValue,
      this.onChanged});

  final List<String> options;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
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

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: context.theme.colorScheme.tertiaryFixed,
            ),
          ),
          width: context.width,
          child: FormBuilderDropdown<String>(
            name: name,
            initialValue: initialValue,
            validator: required == true
                ? FormBuilderValidators.required(
                    errorText: '$title is required')
                : null,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            items: options
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    ))
                .toList(),
            onChanged: onChanged,
            style: context.theme.textStyles.body.copyWith(
              color: context.theme.colors.dark,
            ),
            dropdownColor: context.theme.colorScheme.surface,
            icon: const Icon(IconlyLight.arrow_down_2),
            iconSize: 24,
          ),
        ),
      ],
    );
  }
}
