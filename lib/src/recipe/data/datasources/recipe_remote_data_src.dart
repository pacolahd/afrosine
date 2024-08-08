import 'package:afrosine/core/errors/exceptions.dart';
import 'package:afrosine/core/utils/constants.dart';
import 'package:afrosine/src/recipe/data/models/feedback_model.dart';
import 'package:afrosine/src/recipe/data/models/recipe_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

abstract class RecipeRemoteDataSource {
  const RecipeRemoteDataSource();

  Future<List<RecipeModel>> getRecipes();
  Future<RecipeModel> getRecipeById(String id);
  Future<void> toggleFavoriteRecipe(String userId, String recipeId);
  Future<List<String>> getFavoriteRecipeIds(String userId);
  Future<void> addFeedback(FeedbackModel feedback);
  Future<List<FeedbackModel>> getRecipeFeedback(String recipeId);
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  const RecipeRemoteDataSourceImpl({
    required FirebaseAuth authClient,
    required FirebaseFirestore cloudStoreClient,
    required FirebaseStorage dbClient,
  })  : _authClient = authClient,
        _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient;

  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;

  // @override
  // Future<List<RecipeModel>> getRecipes() async {
  //   try {
  //     final recipeSnapshots =
  //         await _cloudStoreClient.collection('recipes').get();
  //     return recipeSnapshots.docs
  //         .map((doc) => RecipeModel.fromMap(doc.data()))
  //         .toList();
  //   } catch (e, s) {
  //     debugPrintStack(stackTrace: s);
  //     throw ServerException(
  //       message: e.toString(),
  //       statusCode: '500',
  //     );
  //   }
  // }

  @override
  Future<List<RecipeModel>> getRecipes() {
    try {
      // Return a hardcoded list of RecipeModel instances
      return Future.value(dummyRecipes());
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<RecipeModel> getRecipeById(String id) async {
    try {
      final recipeSnapshot =
          await _cloudStoreClient.collection('recipes').doc(id).get();
      if (!recipeSnapshot.exists) {
        throw const ServerException(
          message: 'Recipe not found',
          statusCode: '404',
        );
      }
      return RecipeModel.fromMap(recipeSnapshot.data()!);
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> toggleFavoriteRecipe(String userId, String recipeId) async {
    try {
      final userRef = _cloudStoreClient.collection('users').doc(userId);

      await _cloudStoreClient.runTransaction((transaction) async {
        final userDoc = await transaction.get(userRef);
        if (!userDoc.exists) {
          throw const ServerException(
            message: 'User not found',
            statusCode: '404',
          );
        }

        List<String> favorites = List<String>.from(
            userDoc.data()!['favoriteRecipeIds'] as List<dynamic>? ?? []);

        if (favorites.contains(recipeId)) {
          favorites.remove(recipeId);
        } else {
          favorites.add(recipeId);
        }

        transaction.update(userRef, {'favoriteRecipeIds': favorites});
      });
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<List<String>> getFavoriteRecipeIds(String userId) async {
    try {
      final userDoc =
          await _cloudStoreClient.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw const ServerException(
          message: 'User not found',
          statusCode: '404',
        );
      }
      return List<String>.from(
          userDoc.data()!['favoriteRecipeIds'] as List<dynamic>? ?? []);
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> addFeedback(FeedbackModel feedback) async {
    try {
      await _cloudStoreClient.collection('feedback').add(feedback.toMap());

      // Update the recipe's rating and rating count
      final recipeRef =
          _cloudStoreClient.collection('recipes').doc(feedback.recipeId);
      await _cloudStoreClient.runTransaction((transaction) async {
        final recipeDoc = await transaction.get(recipeRef);
        if (recipeDoc.exists) {
          final currentRating = recipeDoc.data()!['rating'] as double? ?? 0.0;
          final currentCount = recipeDoc.data()!['ratingCount'] as int? ?? 0;

          final newCount = currentCount + 1;
          final newRating =
              ((currentRating * currentCount) + feedback.rating) / newCount;

          transaction.update(recipeRef, {
            'rating': newRating,
            'ratingCount': newCount,
          });
        }
      });
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<List<FeedbackModel>> getRecipeFeedback(String recipeId) async {
    try {
      final feedbackSnapshot = await _cloudStoreClient
          .collection('feedback')
          .where('recipeId', isEqualTo: recipeId)
          .get();

      return feedbackSnapshot.docs
          .map((doc) => FeedbackModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '500');
    }
  }
}
