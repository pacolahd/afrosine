part of 'recipe_bloc.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();
}

class GetRecipesEvent extends RecipeEvent {
  const GetRecipesEvent();
  @override
  List<Object> get props => [];
}

class GetRecipeByIdEvent extends RecipeEvent {
  const GetRecipeByIdEvent(this.recipeId);

  final String recipeId;

  @override
  List<Object> get props => [recipeId];
}

class ToggleFavoriteRecipeEvent extends RecipeEvent {
  const ToggleFavoriteRecipeEvent({
    required this.userId,
    required this.recipeId,
  });

  final String userId;
  final String recipeId;

  @override
  List<Object> get props => [userId, recipeId];
}

class GetFavoriteRecipeIdsEvent extends RecipeEvent {
  const GetFavoriteRecipeIdsEvent(this.userId);

  final String userId;

  @override
  List<Object> get props => [userId];
}

class GetFavoriteRecipesEvent extends RecipeEvent {
  const GetFavoriteRecipesEvent({required this.userId});
  final String userId;

  @override
  List<Object> get props => [userId];
}

class AddFeedbackEvent extends RecipeEvent {
  const AddFeedbackEvent(this.feedback);

  final Feedback feedback;

  @override
  List<Object> get props => [feedback];
}

class GetRecipeFeedbackEvent extends RecipeEvent {
  const GetRecipeFeedbackEvent(this.recipeId);

  final String recipeId;

  @override
  List<Object> get props => [recipeId];
}

class SearchRecipesEvent extends RecipeEvent {
  const SearchRecipesEvent(this.query);
  final String query;

  @override
  List<Object> get props => [query];
}

class FilterRecipesEvent extends RecipeEvent {
  const FilterRecipesEvent(this.params);
  final FilterParams params;

  @override
  List<Object> get props => [params];
}

// class GenerateRecipeEvent extends RecipeEvent {
//   final List<XFile>? images;
//   final List<String> ingredients;
//   final List<String>? cuisines;
//   final List<String>? dietaryRestrictions;
//
//   const GenerateRecipeEvent({
//     this.images,
//     required this.ingredients,
//     this.cuisines,
//     this.dietaryRestrictions,
//   });
//
//   @override
//   List<Object?> get props => [images, ingredients, cuisines, dietaryRestrictions];
// }

class GenerateRecipesEvent extends RecipeEvent {
  const GenerateRecipesEvent({
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
