part of 'recipe_bloc.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object> get props => [];
}

class RecipeInitial extends RecipeState {
  const RecipeInitial();
}

class RecipeLoading extends RecipeState {
  const RecipeLoading();
}

class RecipesLoaded extends RecipeState {
  const RecipesLoaded({required this.recipes});

  final List<Recipe> recipes;

  @override
  List<Object> get props => [recipes];
}

class RecipeLoaded extends RecipeState {
  const RecipeLoaded({required this.recipe});

  final Recipe recipe;

  @override
  List<Object> get props => [recipe];
}

class FavoriteToggled extends RecipeState {
  const FavoriteToggled();
}

class FavoriteRecipeIdsLoaded extends RecipeState {
  const FavoriteRecipeIdsLoaded({required this.favoriteIds});

  final List<String> favoriteIds;

  @override
  List<Object> get props => [favoriteIds];
}

class FavoriteRecipesLoaded extends RecipeState {
  const FavoriteRecipesLoaded({required this.favoriteRecipeIds});
  final List<String> favoriteRecipeIds;

  @override
  List<Object> get props => [favoriteRecipeIds];
}

class RecipeError extends RecipeState {
  const RecipeError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

class FeedbackAdded extends RecipeState {
  const FeedbackAdded();

  @override
  List<Object> get props => [];
}

class RecipeFeedbackLoaded extends RecipeState {
  const RecipeFeedbackLoaded({required this.feedback});

  final List<Feedback> feedback;

  @override
  List<Object> get props => [feedback];
}

class RecipesSearched extends RecipeState {
  const RecipesSearched({required this.recipes});
  final List<Recipe> recipes;

  @override
  List<Object> get props => [recipes];
}

class RecipesFiltered extends RecipeState {
  const RecipesFiltered({required this.recipes});
  final List<Recipe> recipes;

  @override
  List<Object> get props => [recipes];
}

// class RecipeGenerated extends RecipeState {
//   const RecipeGenerated({required this.recipe});
//
//   final Recipe recipe;
//
//   @override
//   List<Object> get props => [recipe];
// }

class RecipesGenerated extends RecipeState {
  const RecipesGenerated({required this.recipes});
  final List<Recipe> recipes;

  @override
  List<Object> get props => [recipes];
}
