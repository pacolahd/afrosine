import 'package:afrosine/core/common/widgets/custom_form_builder_text_field.dart';
import 'package:flutter/material.dart';

class FormBuilderSearchField extends StatelessWidget {
  const FormBuilderSearchField({
    required this.name,
    required this.hintText,
    super.key,
    this.enabled,
    this.iconLeft,
  });
  final String name;
  final String hintText;
  final bool? enabled;
  final bool? iconLeft;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          if (iconLeft == null || (iconLeft != null && iconLeft == false))
            const SizedBox(width: 20)
          else
            const SizedBox(),
          // Leading Icon
          if (iconLeft == null || (iconLeft != null && iconLeft == false))
            const Icon(Icons.search_sharp)
          else
            const SizedBox(),
          // Search Field with no border
          Expanded(
            child: CustomFormBuilderTextField(
              name: name,
              hintText: hintText,
              border: InputBorder.none,
              enabled: enabled ?? true,
            ),
          ),
          // Leading Icon
          if (iconLeft == true)
            const Icon(Icons.search_sharp)
          else
            const SizedBox(),
          if (iconLeft == true) const SizedBox(width: 20) else const SizedBox(),
        ],
      ),
    );
  }
}
