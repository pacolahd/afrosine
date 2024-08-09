import 'package:afrosine/src/recipe/domain/entities/feedback.dart';
import 'package:afrosine/src/recipe/domain/entities/recipe.dart';
import 'package:afrosine/src/recipe/domain/usecases/get_recipes.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final Map<String, List<String>> currentFilters = {};
  RecipeBloc({
    required GetRecipes getRecipes,
    required GetRecipeById getRecipeById,
    required ToggleFavoriteRecipe toggleFavoriteRecipe,
    required GetFavoriteRecipeIds getFavoriteRecipeIds,
    required AddFeedback addFeedback,
    required GetRecipeFeedback getRecipeFeedback,
    required SearchRecipes searchRecipes,
    required FilterRecipes filterRecipes,
    required GenerateRecipes generateRecipes,
  })  : _getRecipes = getRecipes,
        _getRecipeById = getRecipeById,
        _toggleFavoriteRecipe = toggleFavoriteRecipe,
        _getFavoriteRecipeIds = getFavoriteRecipeIds,
        _addFeedback = addFeedback,
        _getRecipeFeedback = getRecipeFeedback,
        _searchRecipes = searchRecipes,
        _filterRecipes = filterRecipes,
        _generateRecipes = generateRecipes,
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
    on<SearchRecipesEvent>(_searchRecipesHandler);
    on<FilterRecipesEvent>(_filterRecipesHandler);
    on<GenerateRecipesEvent>(_generateRecipesHandler);
    on<GetFavoriteRecipesEvent>(_getFavoriteRecipesHandler);
  }

  final GetRecipes _getRecipes;
  final GetRecipeById _getRecipeById;
  final ToggleFavoriteRecipe _toggleFavoriteRecipe;
  final GetFavoriteRecipeIds _getFavoriteRecipeIds;
  final AddFeedback _addFeedback;
  final GetRecipeFeedback _getRecipeFeedback;
  final SearchRecipes _searchRecipes;
  final FilterRecipes _filterRecipes;
  final GenerateRecipes _generateRecipes;

  Future<void> _generateRecipesHandler(
    GenerateRecipesEvent event,
    Emitter<RecipeState> emit,
  ) async {
    emit(const RecipeLoading());
    final result = await _generateRecipes(
      GenerateRecipesParams(
        images: event.images,
        ingredients: event.ingredients,
        cuisines: event.cuisines,
        dietaryRestrictions: event.dietaryRestrictions,
      ),
    );
    result.fold(
      (failure) => emit(RecipeError(message: failure.message)),
      (recipes) => emit(RecipesGenerated(recipes: recipes)),
    );
  }

  // Future<void> _generateRecipeHandler(
  //   GenerateRecipeEvent event,
  //   Emitter<RecipeState> emit,
  // ) async {
  //   emit(const RecipeLoading());
  //   final result = await _generateRecipe(
  //     GenerateRecipeParams(
  //       images: event.images,
  //       ingredients: event.ingredients,
  //       cuisines: event.cuisines,
  //       dietaryRestrictions: event.dietaryRestrictions,
  //     ),
  //   );
  //   result.fold(
  //     (failure) => emit(RecipeError(message: failure.message)),
  //     (recipe) => emit(RecipeGenerated(recipe: recipe)),
  //   );
  // }

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
    try {
      await _toggleFavoriteRecipe(
        ToggleFavoriteRecipeParams(
          userId: event.userId,
          recipeId: event.recipeId,
        ),
      );

      // Get the updated list of favorite recipe IDs
      final result = await _getFavoriteRecipeIds(event.userId);
      result.fold(
        (failure) => emit(RecipeError(message: failure.message)),
        (favoriteIds) {
          emit(FavoriteRecipesLoaded(favoriteRecipeIds: favoriteIds));
          emit(FavoriteToggled());
        },
      );
    } catch (e) {
      emit(RecipeError(message: e.toString()));
    }
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

  Future<void> _getFavoriteRecipesHandler(
    GetFavoriteRecipesEvent event,
    Emitter<RecipeState> emit,
  ) async {
    emit(const RecipeLoading());
    final result = await _getFavoriteRecipeIds(event.userId);
    await result.fold(
      (failure) async => emit(RecipeError(message: failure.message)),
      (favoriteIds) async {
        emit(FavoriteRecipesLoaded(favoriteRecipeIds: favoriteIds));
        final recipesResult = await _getRecipes();
        await recipesResult.fold(
          (failure) async => emit(RecipeError(message: failure.message)),
          (allRecipes) async {
            final favoriteRecipes = allRecipes
                .where((recipe) => favoriteIds.contains(recipe.id))
                .toList();
            emit(RecipesLoaded(recipes: favoriteRecipes));
          },
        );
      },
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

  Future<void> _searchRecipesHandler(
    SearchRecipesEvent event,
    Emitter<RecipeState> emit,
  ) async {
    emit(const RecipeLoading());
    final result = await _searchRecipes(event.query);
    result.fold(
      (failure) => emit(RecipeError(message: failure.message)),
      (recipes) => emit(RecipesLoaded(recipes: recipes)),
    );
  }

  Future<void> _filterRecipesHandler(
    FilterRecipesEvent event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    currentFilters.clear();
    if (event.params.dishTypes != null)
      currentFilters['Dish type'] = event.params.dishTypes!;
    if (event.params.preparationMethods != null)
      currentFilters['Preparation method'] = event.params.preparationMethods!;
    if (event.params.cuisineTypes != null)
      currentFilters['Cuisine type'] = event.params.cuisineTypes!;
    if (event.params.spiceLevels != null)
      currentFilters['Spice level'] = event.params.spiceLevels!;
    if (event.params.servingSizes != null)
      currentFilters['Serving size'] = event.params.servingSizes!;

    final result = await _filterRecipes(event.params);
    result.fold(
      (failure) => emit(RecipeError(message: failure.message)),
      (recipes) => emit(RecipesLoaded(recipes: recipes)),
    );
  }
}
