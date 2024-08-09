import 'package:afrosine/core/errors/exceptions.dart';
import 'package:afrosine/core/errors/failures.dart';
import 'package:afrosine/core/utils/typedefs.dart';
import 'package:afrosine/src/recipe/data/datasources/recipe_remote_data_src.dart';
import 'package:afrosine/src/recipe/data/models/feedback_model.dart';
import 'package:afrosine/src/recipe/domain/entities/feedback.dart';
import 'package:afrosine/src/recipe/domain/entities/recipe.dart';
import 'package:afrosine/src/recipe/domain/repos/recipe_repo.dart';
import 'package:afrosine/src/recipe/domain/usecases/get_recipes.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class RecipeRepoImpl implements RecipeRepository {
  const RecipeRepoImpl(this._remoteDataSource);
  final RecipeRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<Recipe> generateRecipe({
    List<XFile>? images,
    required List<String> ingredients,
    List<String>? cuisines,
    List<String>? dietaryRestrictions,
  }) async {
    try {
      final recipe = await _remoteDataSource.generateRecipe(
        images: images,
        ingredients: ingredients,
        cuisines: cuisines,
        dietaryRestrictions: dietaryRestrictions,
      );
      return Right(recipe);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

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
      String userId, String recipeId) async {
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
      await _remoteDataSource.addFeedback(
        FeedbackModel(
          id: feedback.id,
          userId: feedback.userId,
          recipeId: feedback.recipeId,
          rating: feedback.rating,
          comment: feedback.comment,
          createdAt: feedback.createdAt,
        ),
      );
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
  ResultFuture<List<Recipe>> searchRecipes(String query) async {
    try {
      final recipes = await _remoteDataSource.searchRecipes(query);
      return Right(recipes);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<Recipe>> filterRecipes(FilterParams params) async {
    try {
      final recipes = await _remoteDataSource.filterRecipes(params);
      return Right(recipes);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}

// class RecipeRepoImpl implements RecipeRepository {
//   const RecipeRepoImpl(this._remoteDataSource, this._localDataSource);
//   final RecipeRemoteDataSource _remoteDataSource;
//   final RecipeLocalDataSource _localDataSource;
//
//   // @override
//   // ResultFuture<List<Recipe>> getRecipes({bool forceRefresh = false}) async {
//   //   if (!forceRefresh) {
//   //     try {
//   //       final localRecipes = await _localDataSource.getCachedRecipes();
//   //       if (localRecipes.isNotEmpty) {
//   //         return Right(localRecipes);
//   //       }
//   //     } catch (_) {
//   //       // If there's an error reading from local, we'll try remote
//   //     }
//   //   }
//   //
//   //   try {
//   //     final remoteRecipes = await _remoteDataSource.getRecipes();
//   //     await _localDataSource.cacheRecipes(remoteRecipes);
//   //     return Right(remoteRecipes);
//   //   } on ServerException catch (e) {
//   //     // If remote fails, try to return local data as a fallback
//   //     try {
//   //       final localRecipes = await _localDataSource.getCachedRecipes();
//   //       return Right(localRecipes);
//   //     } catch (_) {
//   //       // If both remote and local fail, return the original error
//   //       return Left(
//   //           ServerFailure(message: e.message, statusCode: e.statusCode));
//   //     }
//   //   }
//   // }
//
//   @override
//   ResultFuture<List<Recipe>> getRecipes({bool forceRefresh = false}) async {
//     if (!forceRefresh) {
//       try {
//         final localRecipes = await _localDataSource.getCachedRecipes();
//         if (localRecipes.isNotEmpty) {
//           return Right(localRecipes);
//         }
//       } catch (localException) {
//         // Log the local exception (or handle it as needed)
//         debugPrint('Local data source exception: $localException');
//       }
//     }
//
//     try {
//       final remoteRecipes = await _remoteDataSource.getRecipes();
//       await _localDataSource.cacheRecipes(remoteRecipes);
//       return Right(remoteRecipes);
//     } on ServerException catch (e) {
//       // If remote fails, try to return local data as a fallback
//       try {
//         final localRecipes = await _localDataSource.getCachedRecipes();
//         return Right(localRecipes);
//       } catch (localException) {
//         // Log the local exception (or handle it as needed)
//         debugPrint(
//             'Local data source exception during fallback: $localException');
//         // If both remote and local fail, return the original error
//         return Left(
//             ServerFailure(message: e.message, statusCode: e.statusCode));
//       }
//     }
//   }
//
//   @override
//   ResultFuture<Recipe> getRecipeById(String id) async {
//     try {
//       final localRecipe = await _localDataSource.getCachedRecipeById(id);
//       if (localRecipe != null) {
//         return Right(localRecipe);
//       }
//     } catch (_) {
//       // If there's an error reading from local, we'll try remote
//     }
//
//     try {
//       final remoteRecipe = await _remoteDataSource.getRecipeById(id);
//       await _localDataSource.cacheRecipes([remoteRecipe]);
//       return Right(remoteRecipe);
//     } on ServerException catch (e) {
//       // If remote fails, try to return local data as a fallback
//       try {
//         final localRecipe = await _localDataSource.getCachedRecipeById(id);
//         if (localRecipe != null) {
//           return Right(localRecipe);
//         }
//       } catch (_) {}
//       return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
//     }
//   }
//
//   @override
//   ResultFuture<void> toggleFavoriteRecipe(
//     String userId,
//     String recipeId,
//   ) async {
//     try {
//       await _remoteDataSource.toggleFavoriteRecipe(userId, recipeId);
//       final favoriteIds = await _remoteDataSource.getFavoriteRecipeIds(userId);
//       final isFavorite = favoriteIds.contains(recipeId);
//       await _localDataSource.updateFavoriteStatus(recipeId, isFavorite);
//       return const Right(null);
//     } on ServerException catch (e) {
//       // If remote fails, update local and inform the user about sync issues
//       await _localDataSource.updateFavoriteStatus(recipeId, true);
//       return Left(
//         ServerFailure(
//           message: 'Changes saved locally but not synced. ${e.message}',
//           statusCode: e.statusCode,
//         ),
//       );
//     }
//   }
//
//   @override
//   ResultFuture<List<String>> getFavoriteRecipeIds(String userId) async {
//     try {
//       final remoteIds = await _remoteDataSource.getFavoriteRecipeIds(userId);
//       await Future.forEach(remoteIds, (String id) async {
//         await _localDataSource.updateFavoriteStatus(id, true);
//       });
//       return Right(remoteIds);
//     } on ServerException catch (e) {
//       // If remote fails, return local favorites
//       try {
//         final localIds = await _localDataSource.getFavoriteRecipeIds();
//         return Right(localIds);
//       } catch (_) {
//         return Left(
//           ServerFailure(message: e.message, statusCode: e.statusCode),
//         );
//       }
//     }
//   }
//
//   @override
//   // When new feedback is added, it's sent to the remote server.
//   // After successful remote addition, we fetch the updated recipe (which now includes the new feedback).
//   // We then update our local storage with this new version of the recipe.
//   ResultFuture<void> addFeedback(Feedback feedback) async {
//     try {
//       await _remoteDataSource.addFeedback(FeedbackModel(
//         id: feedback.id,
//         userId: feedback.userId,
//         recipeId: feedback.recipeId,
//         rating: feedback.rating,
//         comment: feedback.comment,
//         createdAt: feedback.createdAt,
//       ));
//
//       // After adding feedback, fetch the updated recipe
//       final updatedRecipe =
//           await _remoteDataSource.getRecipeById(feedback.recipeId);
//
//       // Update the local cache with the new recipe data
//       await _localDataSource.cacheRecipes([updatedRecipe]);
//
//       return const Right(null);
//     } on ServerException catch (e) {
//       return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
//     }
//   }
//
//   @override
//   // First tries to get feedback from the local cache.
//   // If local cache doesn't have the feedback or is empty, it fetches from the remote database.
//   // After fetching from remote, it updates the local cache with the latest recipe data (including feedback).
//   ResultFuture<List<Feedback>> getRecipeFeedback(String recipeId) async {
//     try {
//       // First, try to get feedback from the local cache
//       final localRecipe = await _localDataSource.getCachedRecipeById(recipeId);
//       if (localRecipe != null && localRecipe.feedback.isNotEmpty) {
//         return Right(localRecipe.feedback);
//       }
//
//       // If local cache doesn't have the feedback, fetch from remote
//       final feedbacks = await _remoteDataSource.getRecipeFeedback(recipeId);
//
//       // Update the local cache with the new feedback
//       final updatedRecipe = await _remoteDataSource.getRecipeById(recipeId);
//       await _localDataSource.cacheRecipes([updatedRecipe]);
//
//       return Right(feedbacks);
//     } on ServerException catch (e) {
//       return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
//     }
//   }
//
//   @override
//   ResultFuture<List<Recipe>> searchRecipes(String query) async {
//     try {
//       final localResults = await _localDataSource.searchRecipes(query);
//       return Right(localResults);
//     } catch (e) {
//       return Left(
//           CacheFailure(message: e.toString(), statusCode: 'search/error'));
//     }
//   }
//
//   @override
//   ResultFuture<List<Recipe>> filterRecipes(FilterParams params) async {
//     try {
//       final recipes = await _localDataSource.filterRecipes(params);
//       return Right(recipes);
//     } on CacheException catch (e) {
//       return Left(CacheFailure(
//           message: e.message, statusCode: e.statusCode ?? 'filter/error'));
//     }
//   }
//
//   // @override
//   // ResultFuture<List<Recipe>> filterRecipes(
//   //     {List<String>? mealTypes,
//   //     String? cuisine,
//   //     String? dishType,
//   //     String? preparationMethod,
//   //     String? spiceLevel,
//   //     String? servingSize}) {
//   //   // TODO: implement filterRecipes
//   //   throw UnimplementedError();
//   // }
// }
