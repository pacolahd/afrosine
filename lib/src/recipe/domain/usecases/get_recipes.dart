import 'package:afrosine/core/errors/failures.dart';
import 'package:afrosine/core/usecases/usecases.dart';
import 'package:afrosine/core/utils/typedefs.dart';
import 'package:afrosine/src/recipe/domain/entities/feedback.dart';
import 'package:afrosine/src/recipe/domain/entities/recipe.dart';
import 'package:afrosine/src/recipe/domain/repos/recipe_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class GetRecipes implements UseCaseWithoutParams<List<Recipe>> {
  GetRecipes(this._repository);
  final RecipeRepository _repository;

  @override
  ResultFuture<List<Recipe>> call() => _repository.getRecipes();
}

class GenerateRecipes
    implements UseCaseWithParams<List<Recipe>, GenerateRecipesParams> {
  const GenerateRecipes(this._repo);

  final RecipeRepository _repo;

  @override
  ResultFuture<List<Recipe>> call(GenerateRecipesParams params) async =>
      _repo.generateRecipes(
        images: params.images,
        ingredients: params.ingredients,
        cuisines: params.cuisines,
        dietaryRestrictions: params.dietaryRestrictions,
      );
}

class GenerateRecipesParams extends Equatable {
  const GenerateRecipesParams({
    this.images,
    required this.ingredients,
    this.cuisines,
    this.dietaryRestrictions,
  });
  final List<XFile>? images;
  final List<String> ingredients;
  final List<String>? cuisines;
  final List<String>? dietaryRestrictions;

  @override
  List<Object?> get props =>
      [images, ingredients, cuisines, dietaryRestrictions];
}

class GetRecipeById implements UseCaseWithParams<Recipe, String> {
  GetRecipeById(this._repository);
  final RecipeRepository _repository;

  @override
  ResultFuture<Recipe> call(String recipeId) =>
      _repository.getRecipeById(recipeId);
}

class ToggleFavoriteRecipe
    implements UseCaseWithParams<List<String>, ToggleFavoriteRecipeParams> {
  final RecipeRepository repository;

  ToggleFavoriteRecipe(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(
      ToggleFavoriteRecipeParams params) async {
    return await repository.toggleFavoriteRecipe(
        params.userId, params.recipeId);
  }
}

class ToggleFavoriteRecipeParams {
  ToggleFavoriteRecipeParams({required this.userId, required this.recipeId});
  final String userId;
  final String recipeId;
}

class GetFavoriteRecipeIds implements UseCaseWithParams<List<String>, String> {
  GetFavoriteRecipeIds(this._repository);
  final RecipeRepository _repository;

  @override
  ResultFuture<List<String>> call(String userId) =>
      _repository.getFavoriteRecipeIds(userId);
}

class AddFeedback implements UseCaseWithParams<void, Feedback> {
  AddFeedback(this._repository);
  final RecipeRepository _repository;

  @override
  ResultFuture<void> call(Feedback feedback) =>
      _repository.addFeedback(feedback);
}

class GetRecipeFeedback implements UseCaseWithParams<List<Feedback>, String> {
  GetRecipeFeedback(this._repository);
  final RecipeRepository _repository;

  @override
  ResultFuture<List<Feedback>> call(String recipeId) =>
      _repository.getRecipeFeedback(recipeId);
}

class SearchRecipes implements UseCaseWithParams<List<Recipe>, String> {
  SearchRecipes(this._repository);
  final RecipeRepository _repository;

  @override
  ResultFuture<List<Recipe>> call(String query) =>
      _repository.searchRecipes(query);
}

class FilterRecipes implements UseCaseWithParams<List<Recipe>, FilterParams> {
  FilterRecipes(this.repository);
  final RecipeRepository repository;

  @override
  ResultFuture<List<Recipe>> call(FilterParams params) =>
      repository.filterRecipes(params);
}

class FilterParams extends Equatable {
  final List<String>? mealTypes;
  final List<String>? dishTypes;
  final List<String>? preparationMethods;
  final List<String>? cuisineTypes;
  final List<String>? spiceLevels;
  final List<String>? servingSizes;

  const FilterParams({
    this.mealTypes,
    this.dishTypes,
    this.preparationMethods,
    this.cuisineTypes,
    this.spiceLevels,
    this.servingSizes,
  });

  bool get isEmpty =>
      mealTypes == null &&
      cuisineTypes == null &&
      dishTypes == null &&
      preparationMethods == null &&
      spiceLevels == null &&
      servingSizes == null;

  bool get isNotEmpty => !isEmpty;

  @override
  String toString() {
    return 'FilterParams{mealTypes: $mealTypes, cuisineTypes: $cuisineTypes, dishTypes: $dishTypes, preparationMethods: $preparationMethods, spiceLevels: $spiceLevels, servingSizes: $servingSizes}';
  }

  Map<String, dynamic> toJson() {
    return {
      'mealTypes': mealTypes,
      'cuisineTypes': cuisineTypes,
      'dishTypes': dishTypes,
      'preparationMethods': preparationMethods,
      'spiceLevels': spiceLevels,
      'servingSizes': servingSizes,
    };
  }

  @override
  List<Object?> get props => [
        mealTypes,
        dishTypes,
        preparationMethods,
        cuisineTypes,
        spiceLevels,
        servingSizes
      ];
}

// class FilterRecipesUsecase implements UseCase<List<Recipe>, FilterParams> {
//   final RecipeRepository _repository;
//
//   FilterRecipesUsecase(this._repository);
//
//   @override
//   Future<Either<Failure, List<Recipe>>> call(FilterParams params) async {
//     return await _repository.filterRecipes(
//       mealTypes: params.mealTypes,
//       cuisine: params.cuisine,
//       dishType: params.dishType,
//       preparationMethod: params.preparationMethod,
//       spiceLevel: params.spiceLevel,
//       servingSize: params.servingSize,
//     );
//   }
// }
//
// class FilterParams {
//   final List<String>? mealTypes;
//   final String? cuisine;
//   final String? dishType;
//   final String? preparationMethod;
//   final String? spiceLevel;
//   final String? servingSize;
//
//   FilterParams({
//     this.mealTypes,
//     this.cuisine,
//     this.dishType,
//     this.preparationMethod,
//     this.spiceLevel,
//     this.servingSize,
//   });
// }
//

// List<Recipe> filterRecipes(List<Recipe> recipes, FilterParams params) {
//   return recipes.where((recipe) {
//     bool matchesMealType = params.mealTypes == null ||
//         params.mealTypes!.any((type) => recipe.mealTypes.contains(type));
//     bool matchesCuisine = params.cuisine == null || recipe.cuisine == params.cuisine;
//     // ... add other filter conditions
//     return matchesMealType && matchesCuisine /* && other conditions */;
//   }).toList();
// }
