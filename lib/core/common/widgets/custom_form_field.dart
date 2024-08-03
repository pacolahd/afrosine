import 'package:afrosine/core/common/widgets/headings.dart';
import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    required this.label,
    required this.controller,
    required this.hintText,
    this.borderHeight,
    this.contentSpacing,
    this.overrideValidator = false,
    this.focusNode,
    this.validator,
    super.key,
    this.borderWidth,
    this.textFieldWidth,
    this.contentHeight,
    this.suffixText,
    this.boldHeading = false,
    this.fieldDistanceFromTop,
    this.keyboardType,
  });
  final String label;
  final bool overrideValidator;

  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final String? suffixText;
  final double? borderWidth;
  final double? textFieldWidth;
  final double? borderHeight;
  final double? contentSpacing;
  final double? contentHeight;
  final bool boldHeading;
  final double? fieldDistanceFromTop;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    const _previousText = '';
    final bodyBold = context.theme.textStyles.bodyBold
        .copyWith(color: context.theme.colors.dark, fontSize: 17);
    final bodyNormal = context.theme.textStyles.body
        .copyWith(color: context.theme.colors.dark, fontSize: 17);

    return Stack(
      children: [
        SizedBox(
          width: borderWidth ?? 160,
          height: borderHeight ?? 90,
        ),
        SizedBox(
          width: borderWidth ?? 160,
          height: contentHeight ?? 70,
          child: Stack(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: context.theme.colorScheme.tertiaryFixed,
                  ),
                ),
              ),
              Positioned(
                top: 11,
                left: 10,
                child: boldHeading
                    ? CaptionBoldTextHeading(title: label)
                    : CaptionTextHeading(title: label),
              ),
            ],
          ),
        ),
        Positioned(
            top: fieldDistanceFromTop ?? 38.5,
            left: 10,
            child: SizedBox(
              width: textFieldWidth ?? 140,
              child: TextFormField(
                // initialValue: '20,000 XAF',
                controller: controller,
                validator: overrideValidator
                    ? validator
                    : (value) {
                        if (value == null || value.isEmpty) {
                          return 'Price is required';
                        }
                        return validator?.call(value);
                      },
                style: boldHeading ? bodyNormal : bodyBold,

                onTapOutside: (_) {
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  suffixText: suffixText ?? 'XAF',
                  suffixStyle: boldHeading ? bodyNormal : bodyBold,
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintText: hintText,
                  hintStyle: context.theme.textStyles.body.copyWith(
                    color: context.theme.colors.milkyWhite,
                  ),
                ),
                keyboardType: keyboardType ?? TextInputType.number,
                onChanged: (text) {
                  // if (text != _previousText) {
                  //   String formattedNumber =
                  //       formatCurrency(double.tryParse(text) ?? 0.0);
                  //   controller.text = formattedNumber;
                  //   _previousText = text;
                  // }

                  // You can use the formatted number here (e.g., for validation)
                },
              ),
            )),
      ],
    );
  }
}
