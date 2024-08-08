import 'package:afrosine/core/errors/exceptions.dart';
import 'package:afrosine/core/errors/failures.dart';
import 'package:afrosine/core/utils/typedefs.dart';
import 'package:afrosine/src/recipe/data/datasources/recipe_remote_data_src.dart';
import 'package:afrosine/src/recipe/data/models/feedback_model.dart';
import 'package:afrosine/src/recipe/domain/entities/feedback.dart';
import 'package:afrosine/src/recipe/domain/entities/recipe.dart';
import 'package:afrosine/src/recipe/domain/repos/recipe_repo.dart';
import 'package:dartz/dartz.dart';

class RecipeRepoImpl implements RecipeRepository {
  const RecipeRepoImpl(this._remoteDataSource);
  final RecipeRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<List<Recipe>> getRecipes() async {
    try {
      final recipes = await _remoteDataSource.getRecipes();
      return Right(recipes);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<Recipe> getRecipeById(String id) async {
    try {
      final recipe = await _remoteDataSource.getRecipeById(id);
      return Right(recipe);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> toggleFavoriteRecipe(
    String userId,
    String recipeId,
  ) async {
    try {
      await _remoteDataSource.toggleFavoriteRecipe(userId, recipeId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<String>> getFavoriteRecipeIds(String userId) async {
    try {
      final favoriteIds = await _remoteDataSource.getFavoriteRecipeIds(userId);
      return Right(favoriteIds);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> addFeedback(Feedback feedback) async {
    try {
      await _remoteDataSource.addFeedback(FeedbackModel(
        id: feedback.id,
        userId: feedback.userId,
        recipeId: feedback.recipeId,
        rating: feedback.rating,
        comment: feedback.comment,
        createdAt: feedback.createdAt,
      ));
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<Feedback>> getRecipeFeedback(String recipeId) async {
    try {
      final feedbacks = await _remoteDataSource.getRecipeFeedback(recipeId);
      return Right(feedbacks);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<Recipe>> filterRecipes(
      {List<String>? mealTypes,
      String? cuisine,
      String? dishType,
      String? preparationMethod,
      String? spiceLevel,
      String? servingSize}) {
    // TODO: implement filterRecipes
    throw UnimplementedError();
  }

  @override
  ResultFuture<List<Recipe>> searchRecipes(String query) {
    // TODO: implement searchRecipes
    throw UnimplementedError();
  }
}
