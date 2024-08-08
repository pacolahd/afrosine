import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  const Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });
  final String name;
  final String quantity;
  final String unit;

  @override
  List<Object?> get props => [name, quantity, unit];

  @override
  String toString() => '$quantity $unit $name';
}
