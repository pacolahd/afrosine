import 'package:afrosine/core/usecases/usecases.dart';
import 'package:afrosine/core/utils/typedefs.dart';
import 'package:afrosine/src/recipe/domain/entities/feedback.dart';
import 'package:afrosine/src/recipe/domain/entities/recipe.dart';
import 'package:afrosine/src/recipe/domain/repos/recipe_repo.dart';

class GetRecipes implements UseCaseWithoutParams<List<Recipe>> {
  GetRecipes(this._repository);
  final RecipeRepository _repository;

  @override
  ResultFuture<List<Recipe>> call() => _repository.getRecipes();
}

class GetRecipeById implements UseCaseWithParams<Recipe, String> {
  GetRecipeById(this._repository);
  final RecipeRepository _repository;

  @override
  ResultFuture<Recipe> call(String recipeId) =>
      _repository.getRecipeById(recipeId);
}

class ToggleFavoriteRecipe
    implements UseCaseWithParams<void, ToggleFavoriteRecipeParams> {
  ToggleFavoriteRecipe(this._repository);
  final RecipeRepository _repository;

  @override
  ResultFuture<void> call(ToggleFavoriteRecipeParams params) {
    return _repository.toggleFavoriteRecipe(params.userId, params.recipeId);
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
