import 'package:afrosine/core/utils/typedefs.dart';
import 'package:afrosine/src/recipe/domain/entities/feedback.dart';
import 'package:afrosine/src/recipe/domain/entities/recipe.dart';
import 'package:afrosine/src/recipe/domain/usecases/get_recipes.dart';
import 'package:image_picker/image_picker.dart';

abstract class RecipeRepository {
  ResultFuture<List<Recipe>> generateRecipes({
    List<XFile>? images,
    required List<String> ingredients,
    List<String>? cuisines,
    List<String>? dietaryRestrictions,
  });

  // ResultFuture<Recipe> generateRecipe({
  //   List<XFile>? images,
  //   required List<String> ingredients,
  //   List<String>? cuisines,
  //   List<String>? dietaryRestrictions,
  // });

  ResultFuture<List<Recipe>> getRecipes();
  ResultFuture<Recipe> getRecipeById(String id);
  ResultFuture<void> toggleFavoriteRecipe(
    String userId,
    String recipeId,
  );
  ResultFuture<List<String>> getFavoriteRecipeIds(String userId);

  ResultFuture<void> addFeedback(Feedback feedback);
  ResultFuture<List<Feedback>> getRecipeFeedback(String recipeId);
  ResultFuture<List<Recipe>> searchRecipes(String query);

  ResultFuture<List<Recipe>> filterRecipes(FilterParams params);
  // Optional. We will Implement these methods if you want to add search and filter functionality
  // For now, search and filter will be done on the client side (presentation layer)

  // ResultFuture<List<Recipe>> filterRecipes({
  //   List<String>? mealTypes,
  //   String? cuisine,
  //   String? dishType,
  //   String? preparationMethod,
  //   String? spiceLevel,
  //   String? servingSize,
  // });
}
