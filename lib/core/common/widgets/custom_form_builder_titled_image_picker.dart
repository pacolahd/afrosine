import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';

class CustomFormBuilderTitledImagePicker extends StatelessWidget {
  @override
  final String name;
  final bool? required;
  final String labelText;
  final String hintText;
  final String title;
  final FormFieldValidator<List<dynamic>>? validator;
  final ValueChanged<List<dynamic>?>? onChanged;

  const CustomFormBuilderTitledImagePicker({
    Key? key,
    required this.name,
    required this.labelText,
    required this.hintText,
    this.validator,
    this.onChanged,
    required this.title,
    this.required = true,
  }) : super(key: key);

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
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            hintText,
            style: context.theme.textStyles.body.copyWith(
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.all(8.0),
          child: FormBuilderImagePicker(
            name: name,
            displayCustomType: (obj) => obj is XFile ? obj.path : obj,
            maxImages: 1,
            placeholderWidget: const Center(
              child: Icon(
                Icons.add_photo_alternate_outlined,
                color: Colors.blue, // Customize placeholder icon color
                size: 70,
              ),
            ),
            validator: validator ??
                FormBuilderValidators.required(errorText: '$title is required'),

            onChanged: onChanged,
            imageQuality: 80, // Optional: to reduce the image size
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            cameraIcon: const Icon(
              Icons.camera_alt,
            ), // Optional: customize camera icon
            galleryIcon: const Icon(
              Icons.photo_library,
            ), // Optional: customize gallery icon
            iconColor: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
