import 'dart:convert';

import 'package:afrosine/core/errors/exceptions.dart';
import 'package:afrosine/core/utils/typedefs.dart';
import 'package:afrosine/src/recipe/data/datasources/gemini_ai_service.dart';
import 'package:afrosine/src/recipe/data/models/feedback_model.dart';
import 'package:afrosine/src/recipe/data/models/recipe_model.dart';
import 'package:afrosine/src/recipe/domain/usecases/get_recipes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

abstract class RecipeRemoteDataSource {
  const RecipeRemoteDataSource();

  Future<List<RecipeModel>> generateRecipes({
    List<XFile>? images,
    required List<String> ingredients,
    List<String>? cuisines,
    List<String>? dietaryRestrictions,
  });

  // Future<RecipeModel> generateRecipe({
  //   List<XFile>? images,
  //   required List<String> ingredients,
  //   List<String>? cuisines,
  //   List<String>? dietaryRestrictions,
  // });
  Future<List<RecipeModel>> getRecipes();
  Future<RecipeModel> getRecipeById(String id);
  Future<void> toggleFavoriteRecipe(String userId, String recipeId);
  Future<List<String>> getFavoriteRecipeIds(String userId);
  Future<void> addFeedback(FeedbackModel feedback);
  Future<List<FeedbackModel>> getRecipeFeedback(String recipeId);
  Future<List<RecipeModel>> searchRecipes(String query);
  Future<List<RecipeModel>> filterRecipes(FilterParams params);
  Future<void> addRecipeToFirebase(RecipeModel recipe);
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  const RecipeRemoteDataSourceImpl({
    required FirebaseAuth authClient,
    required FirebaseFirestore cloudStoreClient,
    required FirebaseStorage dbClient,
    required GeminiAIService geminiAIService,
  })  : _authClient = authClient,
        _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient,
        _geminiAIService = geminiAIService;

  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;
  final GeminiAIService _geminiAIService;

  // @override
  // Future<RecipeModel> generateRecipe({
  //   List<XFile>? images,
  //   required List<String> ingredients,
  //   List<String>? cuisines,
  //   List<String>? dietaryRestrictions,
  // }) async {
  //   try {
  //     final jsonString = await _geminiAIService.generateRecipe(
  //       images: images,
  //       ingredients: ingredients,
  //       cuisines: cuisines,
  //       dietaryRestrictions: dietaryRestrictions,
  //     );
  //     final recipeMap = json.decode(jsonString) as DataMap;
  //     return RecipeModel.fromMap(recipeMap);
  //   } catch (e) {
  //     debugPrint('Error generating recipe: ${e.toString()}');
  //     if (e is FormatException) {
  //       throw const ServerException(
  //         message: 'Invalid response format from AI service',
  //         statusCode: '500',
  //       );
  //     }
  //     throw ServerException(message: e.toString(), statusCode: '500');
  //   }
  // }

  // @override
  // Future<List<RecipeModel>> generateRecipes({
  //   List<XFile>? images,
  //   required List<String> ingredients,
  //   List<String>? cuisines,
  //   List<String>? dietaryRestrictions,
  // }) async {
  //   try {
  //     final jsonString = await _geminiAIService.generateRecipes(
  //       images: images,
  //       ingredients: ingredients,
  //       cuisines: cuisines,
  //       dietaryRestrictions: dietaryRestrictions,
  //     );
  //
  //     debugPrint('Raw JSON string from Gemini AI: $jsonString');
  //
  //     // Try to parse the JSON string
  //     dynamic parsedJson;
  //     try {
  //       parsedJson = json.decode(jsonString);
  //     } catch (e) {
  //       debugPrint('JSON parsing error: ${e.toString()}');
  //       throw FormatException('Invalid JSON response from AI service');
  //     }
  //
  //     // Check if the parsed JSON is a List
  //     if (parsedJson is! List) {
  //       throw FormatException(
  //           'Expected a List of recipes, but got ${parsedJson.runtimeType}');
  //     }
  //
  //     final List<RecipeModel> recipes = [];
  //     for (var recipeMap in parsedJson) {
  //       if (recipeMap is Map<String, dynamic>) {
  //         try {
  //           recipes.add(RecipeModel.fromMap(recipeMap));
  //         } catch (e) {
  //           debugPrint('Error parsing recipe: ${e.toString()}');
  //           // Continue to the next recipe if one fails to parse
  //         }
  //       }
  //     }
  //
  //     if (recipes.isEmpty) {
  //       throw FormatException('No valid recipes found in the AI response');
  //     }
  //
  //     // Automatically add generated recipes to Firebase
  //     for (var recipe in recipes) {
  //       await addRecipeToFirebase(recipe);
  //     }
  //
  //     return recipes;
  //   } catch (e, stackTrace) {
  //     debugPrint('Error generating recipes: ${e.toString()}');
  //     debugPrint('Stack trace: $stackTrace');
  //     if (e is FormatException) {
  //       throw ServerException(message: e.toString(), statusCode: '500');
  //     }
  //     throw ServerException(
  //         message: 'Failed to generate recipes', statusCode: '500');
  //   }
  // }

  // Add this to the RecipeRemoteDataSourceImpl class

  Map<String, String> get preparationMethodImages => {
        'Grilled':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/African_Dishes.jpg/750px-African_Dishes.jpg',
        'Fried':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/African_Dishes.jpg/750px-African_Dishes.jpg',
        'Baked':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/African_Dishes.jpg/750px-African_Dishes.jpg',
        'Roasted':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/African_Dishes.jpg/750px-African_Dishes.jpg',
        'Boiled':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/African_Dishes.jpg/750px-African_Dishes.jpg',
        'Sautéed':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/African_Dishes.jpg/750px-African_Dishes.jpg',
        'Steamed':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/African_Dishes.jpg/750px-African_Dishes.jpg',
        'Braised':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/African_Dishes.jpg/750px-African_Dishes.jpg',
        'Poached':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/African_Dishes.jpg/750px-African_Dishes.jpg',
        'Microwaved':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/African_Dishes.jpg/750px-African_Dishes.jpg',
        'Slow-cooked':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/African_Dishes.jpg/750px-African_Dishes.jpg',
        'Raw':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/African_Dishes.jpg/750px-African_Dishes.jpg',
        'Smoked':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/African_Dishes.jpg/750px-African_Dishes.jpg',
        'Blanched':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/African_Dishes.jpg/750px-African_Dishes.jpg',
        'Broiled':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/African_Dishes.jpg/750px-African_Dishes.jpg',
        'Pressure-cooked':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/African_Dishes.jpg/750px-African_Dishes.jpg',
      };

  @override
  Future<List<RecipeModel>> generateRecipes({
    List<XFile>? images,
    required List<String> ingredients,
    List<String>? cuisines,
    List<String>? dietaryRestrictions,
  }) async {
    try {
      final jsonString = await _geminiAIService.generateRecipes(
        images: images,
        ingredients: ingredients,
        cuisines: cuisines,
        dietaryRestrictions: dietaryRestrictions,
      );

      debugPrint('Cleaned JSON string from Gemini AI: $jsonString');

      final List<dynamic> recipesMap = json.decode(jsonString) as List<dynamic>;
      final List<RecipeModel> recipes = [];

      for (var recipeMap in recipesMap) {
        final recipe = RecipeModel.fromMap(recipeMap as DataMap);

        // Create a new document in Firebase to get an ID
        final docRef = _cloudStoreClient.collection('recipes').doc();

        // Assign the Firebase ID to the recipe
        final updatedRecipe = recipe.copyWith(
          id: docRef.id,
          imageUrl: preparationMethodImages[recipe.preparationMethod] ??
              recipe.imageUrl,
        );

        // Add the updated recipe to Firebase
        await addRecipeToFirebase(updatedRecipe);

        // Add the updated recipe to the list
        recipes.add(updatedRecipe);
      }

      return recipes;
    } catch (e, stackTrace) {
      debugPrint('Error generating recipes: ${e.toString()}');
      debugPrint('Stack trace: $stackTrace');
      if (e is FormatException) {
        throw ServerException(
            message: 'Invalid AI response format: ${e.toString()}',
            statusCode: '500');
      }
      throw ServerException(
          message: 'Failed to generate recipes: ${e.toString()}',
          statusCode: '500');
    }
  }

  @override
  Future<void> addRecipeToFirebase(RecipeModel recipe) async {
    try {
      // Use the recipe's ID (which is now a Firebase ID) to set the document
      await _cloudStoreClient
          .collection('recipes')
          .doc(recipe.id)
          .set(recipe.toMap());
    } catch (e) {
      debugPrint('Error adding recipe to Firebase: ${e.toString()}');
      throw ServerException(
          message: 'Failed to add recipe to database', statusCode: '500');
    }
  }

  @override
  Future<List<RecipeModel>> searchRecipes(String query) async {
    try {
      final theQuery = query.toLowerCase();
      final recipeSnapshots =
          await _cloudStoreClient.collection('recipes').get();

      return recipeSnapshots.docs
          .map((doc) => RecipeModel.fromMap(doc.data()))
          .where((recipe) =>
              recipe.name.toLowerCase().contains(theQuery) ||
              recipe.description.toLowerCase().contains(theQuery) ||
              recipe.ingredients.any((ingredient) =>
                  ingredient.name.toLowerCase().contains(theQuery)) ||
              recipe.cuisine.toLowerCase().contains(theQuery) ||
              recipe.dishType.toLowerCase().contains(theQuery) ||
              recipe.preparationMethod.toLowerCase().contains(theQuery))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<List<RecipeModel>> filterRecipes(FilterParams params) async {
    try {
      Query query = _cloudStoreClient.collection('recipes');

      if (params.mealTypes != null && params.mealTypes!.isNotEmpty) {
        query = query.where('mealTypes', arrayContainsAny: params.mealTypes);
      }
      if (params.cuisineTypes != null && params.cuisineTypes!.isNotEmpty) {
        query = query.where('cuisine', whereIn: params.cuisineTypes);
      }
      if (params.dishTypes != null && params.dishTypes!.isNotEmpty) {
        query = query.where('dishType', whereIn: params.dishTypes);
      }
      if (params.preparationMethods != null &&
          params.preparationMethods!.isNotEmpty) {
        query = query.where('preparationMethod',
            whereIn: params.preparationMethods);
      }
      if (params.spiceLevels != null && params.spiceLevels!.isNotEmpty) {
        query = query.where('spiceLevel', whereIn: params.spiceLevels);
      }
      if (params.servingSizes != null && params.servingSizes!.isNotEmpty) {
        query = query.where('servingSize', whereIn: params.servingSizes);
      }

      final recipeSnapshots = await query.get();
      return recipeSnapshots.docs
          .map((doc) => RecipeModel.fromMap(doc.data()! as DataMap))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<List<RecipeModel>> getRecipes() async {
    try {
      final recipeSnapshots =
          await _cloudStoreClient.collection('recipes').get();
      final recipes = recipeSnapshots.docs
          .map((doc) => RecipeModel.fromMap(doc.data()))
          .toList();
      debugPrint(
          'Recipes OOO: ${recipes.map((rec) => rec.imageUrl).toList().toString()}');
      return recipes;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  // @override
  // Future<List<RecipeModel>> getRecipes() {
  //   try {
  //     // Return a hardcoded list of RecipeModel instances
  //     return Future.value(dummyRecipes());
  //   } catch (e, s) {
  //     debugPrintStack(stackTrace: s);
  //     throw ServerException(
  //       message: e.toString(),
  //       statusCode: '500',
  //     );
  //   }
  // }

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
