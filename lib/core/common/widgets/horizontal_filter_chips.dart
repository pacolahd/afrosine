import 'package:afrosine/core/common/widgets/custom_filter_chip.dart';
import 'package:flutter/material.dart';

class HorizontalFilterChipList extends StatelessWidget {
  const HorizontalFilterChipList({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onItemSelected,
  });
  final List<String> items;
  final String selectedItem;
  final ValueChanged<String> onItemSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: CustomFilterChip(
            label: item,
            isSelected: item == selectedItem,
            onSelected: (isSelected) {
              onItemSelected(item);
            },
          ),
        );
      },
    );
  }
}
