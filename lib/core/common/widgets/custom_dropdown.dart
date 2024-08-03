import 'package:afrosine/core/common/widgets/headings.dart';
import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.height,
    this.spacingFromHeading,
    Key? key,
  }) : super(key: key);
  final double? height;
  final double? spacingFromHeading;
  final String title;
  final List<String> options;
  final String selectedValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Stack(
        children: [
          Container(
            height: height ?? 60,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: context.theme.colorScheme.tertiaryFixed,
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 16,
            child: CaptionBoldTextHeading(title: title),
          ),
          Positioned(
            top: spacingFromHeading ?? 15,
            left: 16,
            child: SizedBox(
              width: context.width * .82,
              child: DropdownButton<String>(
                dropdownColor: context.theme.colorScheme.surface,
                style: context.theme.textStyles.body.copyWith(
                  color: context.theme.colors.dark,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                value: selectedValue,
                isExpanded: true,
                icon: const Icon(
                  IconlyLight.arrow_down_2,
                ),
                iconSize: 24,
                elevation: 16,
                underline: const SizedBox(),
                onChanged: onChanged,
                items: options.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
