import 'package:afrosine/src/recipe/domain/entities/feedback.dart';
import 'package:afrosine/src/recipe/domain/entities/ingredient.dart';
import 'package:equatable/equatable.dart';

class Recipe extends Equatable {
  const Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.cuisine,
    required this.dishType,
    required this.preparationMethod,
    required this.spiceLevel,
    required this.servingSize,
    required this.mealTypes,
    this.rating = 0.0,
    this.ratingCount = 0,
    this.feedback = const [],
  });

  const Recipe.empty()
      : this(
          id: '',
          name: '',
          description: '',
          imageUrl: '',
          ingredients: const [],
          instructions: const [],
          cuisine: '',
          dishType: '',
          preparationMethod: '',
          spiceLevel: '',
          servingSize: '',
          mealTypes: const [],
        );

  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<Ingredient> ingredients;
  final List<String> instructions;
  final String cuisine;
  final String dishType;
  final String preparationMethod;
  final String spiceLevel;
  final String servingSize;
  final List<String> mealTypes;
  final double rating;
  final int ratingCount;
  final List<Feedback> feedback;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        ingredients,
        instructions,
        cuisine,
        dishType,
        preparationMethod,
        spiceLevel,
        servingSize,
        mealTypes,
        rating,
        ratingCount,
        feedback,
      ];

  @override
  String toString() {
    return 'Recipe{id: $id, name: $name, cuisine: $cuisine, dishType: $dishType, mealTypes: $mealTypes, rating: $rating, ratingCount: $ratingCount, feedback: $feedback}';
  }
}
