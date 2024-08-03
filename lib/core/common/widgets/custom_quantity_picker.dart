import 'package:afrosine/core/common/widgets/headings.dart';
import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class QuantityPicker extends StatefulWidget {
  const QuantityPicker({
    required this.title,
    required this.onQuantityChanged,
    super.key,
    this.quantity = 0,
    this.minQuantity = 0,
    this.maxQuantity = 10,
  });

  final String title;
  final int quantity;
  final int minQuantity;
  final int maxQuantity;
  final void Function(int) onQuantityChanged;

  @override
  State<QuantityPicker> createState() => _QuantityPickerState();
}

class _QuantityPickerState extends State<QuantityPicker> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity;
  }

  void _handleDecrement() {
    if (_quantity > widget.minQuantity) {
      setState(() {
        _quantity--;
        widget.onQuantityChanged(_quantity);
      });
    }
  }

  void _handleIncrement() {
    if (_quantity < widget.maxQuantity) {
      setState(() {
        _quantity++;
        widget.onQuantityChanged(_quantity);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Title2Text(title: widget.title),
          Row(
            children: [
              GestureDetector(
                onTap: _handleDecrement,
                child: Icon(
                  Icons.remove,
                  color: context.theme.colorScheme.tertiary,
                ),
              ),
              const SizedBox(width: 25),
              Title2Text(title: _quantity.toString()),
              const SizedBox(width: 25),
              GestureDetector(
                onTap: _handleIncrement,
                child: Icon(
                  Icons.add,
                  color: context.theme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
