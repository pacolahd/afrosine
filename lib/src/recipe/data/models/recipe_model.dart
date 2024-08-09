import 'dart:convert';

import 'package:afrosine/core/utils/typedefs.dart';
import 'package:afrosine/src/recipe/data/models/feedback_model.dart';
import 'package:afrosine/src/recipe/domain/entities/ingredient.dart';
import 'package:afrosine/src/recipe/domain/entities/recipe.dart';

class RecipeModel extends Recipe {
  const RecipeModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.ingredients,
    required super.instructions,
    required super.cuisine,
    required super.dishType,
    required super.preparationMethod,
    required super.spiceLevel,
    required super.servingSize,
    required super.mealTypes,
    super.rating = 0.0,
    super.ratingCount = 0,
    super.feedback = const [],
  });

  const RecipeModel.empty() : super.empty();

  // factory RecipeModel.fromMap(DataMap map) {
  //   return RecipeModel(
  //     id: map['id'] as String,
  //     name: map['name'] as String,
  //     description: map['description'] as String,
  //     imageUrl: map['imageUrl'] as String,
  //     ingredients: (map['ingredients'] as List<dynamic>)
  //         .map(
  //           (ingredientMap) => Ingredient(
  //             name: ingredientMap['name'] as String,
  //             quantity: ingredientMap['quantity'] as String,
  //             unit: ingredientMap['unit'] as String,
  //           ),
  //         )
  //         .toList(),
  //     instructions: List<String>.from(map['instructions'] as List<dynamic>),
  //     cuisine: map['cuisine'] as String,
  //     dishType: map['dishType'] as String,
  //     preparationMethod: map['preparationMethod'] as String,
  //     spiceLevel: map['spiceLevel'] as String,
  //     servingSize: map['servingSize'] as String,
  //     mealTypes: List<String>.from(map['mealTypes'] as List<dynamic>),
  //     rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
  //     ratingCount: map['ratingCount'] as int? ?? 0,
  //     feedback: (map['feedback'] as List<dynamic>?)
  //             ?.map(
  //               (feedbackMap) => FeedbackModel.fromMap(feedbackMap as DataMap),
  //             )
  //             .toList() ??
  //         [],
  //   );
  // }

  factory RecipeModel.fromMap(DataMap map) {
    return RecipeModel(
      id: map['id'] as String? ?? '',
      name: map['recipe_title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      imageUrl: map['image_url'] as String? ?? 'placeholder_image_url',
      ingredients: (map['ingredients'] as List<dynamic>?)
              ?.map(
                (ingredientMap) => Ingredient(
                  name: ingredientMap['name'] as String? ?? '',
                  quantity: ingredientMap['quantity'] as String? ?? '',
                  unit: ingredientMap['unit'] as String? ?? '',
                ),
              )
              .toList() ??
          [],
      instructions:
          List<String>.from(map['instructions'] as List<dynamic>? ?? []),
      cuisine: map['cuisine_type'] as String? ?? '',
      dishType: map['dish_type'] as String? ?? '',
      preparationMethod: map['preparation_method'] as String? ?? '',
      spiceLevel: map['spice_level'] as String? ?? '',
      servingSize: map['serving_size'] as String? ?? '',
      mealTypes: List<String>.from(map['meal_types'] as List<dynamic>? ?? []),
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: map['ratingCount'] as int? ?? 0,
      feedback: (map['feedback'] as List<dynamic>?)
              ?.map(
                (feedbackMap) => FeedbackModel.fromMap(feedbackMap as DataMap),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'ingredients': ingredients
          .map((ingredient) => {
                'name': ingredient.name,
                'quantity': ingredient.quantity,
                'unit': ingredient.unit,
              })
          .toList(),
      'instructions': instructions,
      'cuisine': cuisine,
      'dishType': dishType,
      'preparationMethod': preparationMethod,
      'spiceLevel': spiceLevel,
      'servingSize': servingSize,
      'mealTypes': mealTypes,
      'rating': rating,
      'ratingCount': ratingCount,
      'feedback': feedback.map((f) => (f as FeedbackModel).toMap()).toList(),
    };
  }

  String toJson() => jsonEncode(toMap());

  RecipeModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    List<Ingredient>? ingredients,
    List<String>? instructions,
    String? cuisine,
    String? dishType,
    String? preparationMethod,
    String? spiceLevel,
    String? servingSize,
    List<String>? mealTypes,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      cuisine: cuisine ?? this.cuisine,
      dishType: dishType ?? this.dishType,
      preparationMethod: preparationMethod ?? this.preparationMethod,
      spiceLevel: spiceLevel ?? this.spiceLevel,
      servingSize: servingSize ?? this.servingSize,
      mealTypes: mealTypes ?? this.mealTypes,
    );
  }
}
