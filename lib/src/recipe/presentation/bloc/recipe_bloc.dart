import 'package:afrosine/src/recipe/domain/entities/feedback.dart';
import 'package:afrosine/src/recipe/domain/entities/recipe.dart';
import 'package:afrosine/src/recipe/domain/usecases/get_recipes.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  RecipeBloc({
    required GetRecipes getRecipes,
    required GetRecipeById getRecipeById,
    required ToggleFavoriteRecipe toggleFavoriteRecipe,
    required GetFavoriteRecipeIds getFavoriteRecipeIds,
    required AddFeedback addFeedback,
    required GetRecipeFeedback getRecipeFeedback,
  })  : _getRecipes = getRecipes,
        _getRecipeById = getRecipeById,
        _toggleFavoriteRecipe = toggleFavoriteRecipe,
        _getFavoriteRecipeIds = getFavoriteRecipeIds,
        _addFeedback = addFeedback,
        _getRecipeFeedback = getRecipeFeedback,
        super(const RecipeInitial()) {
    on<RecipeEvent>((event, emit) {
      emit(const RecipeLoading());
    });
    on<GetRecipesEvent>(_getRecipesHandler);
    on<GetRecipeByIdEvent>(_getRecipeByIdHandler);
    on<ToggleFavoriteRecipeEvent>(_toggleFavoriteRecipeHandler);
    on<GetFavoriteRecipeIdsEvent>(_getFavoriteRecipeIdsHandler);
    on<AddFeedbackEvent>(_addFeedbackHandler);
    on<GetRecipeFeedbackEvent>(_getRecipeFeedbackHandler);
  }

  final GetRecipes _getRecipes;
  final GetRecipeById _getRecipeById;
  final ToggleFavoriteRecipe _toggleFavoriteRecipe;
  final GetFavoriteRecipeIds _getFavoriteRecipeIds;
  final AddFeedback _addFeedback;
  final GetRecipeFeedback _getRecipeFeedback;

  Future<void> _getRecipesHandler(
    GetRecipesEvent event,
    Emitter<RecipeState> emit,
  ) async {
    final result = await _getRecipes();
    result.fold(
      (failure) => emit(RecipeError(message: failure.message)),
      (recipes) => emit(RecipesLoaded(recipes: recipes)),
    );
  }

  Future<void> _getRecipeByIdHandler(
    GetRecipeByIdEvent event,
    Emitter<RecipeState> emit,
  ) async {
    final result = await _getRecipeById(event.recipeId);
    result.fold(
      (failure) => emit(RecipeError(message: failure.message)),
      (recipe) => emit(RecipeLoaded(recipe: recipe)),
    );
  }

  Future<void> _toggleFavoriteRecipeHandler(
    ToggleFavoriteRecipeEvent event,
    Emitter<RecipeState> emit,
  ) async {
    final result = await _toggleFavoriteRecipe(
      ToggleFavoriteRecipeParams(
        userId: event.userId,
        recipeId: event.recipeId,
      ),
    );
    result.fold(
      (failure) => emit(RecipeError(message: failure.message)),
      (_) => emit(const FavoriteToggled()),
    );
  }

  Future<void> _getFavoriteRecipeIdsHandler(
    GetFavoriteRecipeIdsEvent event,
    Emitter<RecipeState> emit,
  ) async {
    final result = await _getFavoriteRecipeIds(event.userId);
    result.fold(
      (failure) => emit(RecipeError(message: failure.message)),
      (favoriteIds) => emit(FavoriteRecipeIdsLoaded(favoriteIds: favoriteIds)),
    );
  }

  Future<void> _addFeedbackHandler(
    AddFeedbackEvent event,
    Emitter<RecipeState> emit,
  ) async {
    final result = await _addFeedback(event.feedback);
    result.fold(
      (failure) => emit(RecipeError(message: failure.message)),
      (_) => emit(const FeedbackAdded()),
    );
  }

  Future<void> _getRecipeFeedbackHandler(
    GetRecipeFeedbackEvent event,
    Emitter<RecipeState> emit,
  ) async {
    final result = await _getRecipeFeedback(event.recipeId);
    result.fold(
      (failure) => emit(RecipeError(message: failure.message)),
      (feedback) => emit(RecipeFeedbackLoaded(feedback: feedback)),
    );
  }
}
