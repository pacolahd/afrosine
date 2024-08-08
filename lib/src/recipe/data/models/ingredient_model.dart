import 'package:afrosine/core/utils/typedefs.dart';
import 'package:afrosine/src/recipe/domain/entities/ingredient.dart';

class IngredientModel extends Ingredient {
  const IngredientModel({
    required super.name,
    required super.quantity,
    required super.unit,
  });

  factory IngredientModel.fromMap(DataMap map) {
    return IngredientModel(
      name: map['name'] as String,
      quantity: map['quantity'] as String,
      unit: map['unit'] as String,
    );
  }

  DataMap toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
    };
  }
}
