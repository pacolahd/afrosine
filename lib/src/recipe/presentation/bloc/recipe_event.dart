part of 'recipe_bloc.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class GetRecipesEvent extends RecipeEvent {
  const GetRecipesEvent();
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
