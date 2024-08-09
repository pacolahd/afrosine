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
  Future<List<String>> toggleFavoriteRecipe(String userId, String recipeId);
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

  Map<String, String> get preparationMethodImages => {
        'Grilled':
            'https://static.vecteezy.com/system/resources/thumbnails/030/591/765/small_2x/a-chef-expertly-grilling-a-succulent-steak-over-an-open-flame-with-sizzling-sparks-and-mouthwatering-grill-marks-representing-the-mastery-of-the-culinary-craft-generative-ai-photo.jpeg',
        'Fried':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9JAVGAo10FWvSl3qKSecUV9y6ih3Kw8L05iOoyI8H1mVwvIozbnRiSnl8XQ4p3H6gyug&usqp=CAU',
        'Baked':
            'hhttps://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_qHk71FqlM0yDWs1S4w-jjFGYaqqYqVnjYiRNtTvapGSD3zRKUVH-oVKR9r6cUiuUrOM&usqp=CAU',
        'Roasted':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQz6Aw3QkzB7fgoXt_LYQVzDOwwVYIvNY_VhXxlV1f3y9ZNLCU_XbRDGHD8PxD_hQya5LE&usqp=CAU',
        'Boiled':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVlXlGahzKQE-Xg4T_V69pdd2TnGIQxDIu4w9X7DzLltsl2yFuBkD3mRyNXJBrv-O6H98&usqp=CAU',
        'Sautéed':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkD0qd7Ax--ROIon6bRxtm9wfzLLLTR5wUYn5I18H6h7PTX-FQfo9o9WzdCPW8gbzRfJ8&usqp=CAU',
        'Steamed':
            'https://i0.wp.com/hadipisir.com/wp-content/uploads/2021/03/00-4.jpg?fit=750%2C525&ssl=1',
        'Braised':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQp8H9pDHj8gDYNVo8m5PLtZ0CGTBfwDYgllQeBHqwdBRGGhVW401IYrIK3bChdQyDBq10&usqp=CAU',
        'Poached':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRL1T9sYDZl5m50pRhyuLHCui1SkcYIas0dzekgvTgltjTlvu43yiHUlJgQwRCB-vs2fMo&usqp=CAU',
        'Microwaved':
            'https://id.sharp/sites/default/files/uploads/2021-08/shutterstock_74089945.jpg',
        'Slow-cooked':
            'https://images.immediate.co.uk/production/volatile/sites/30/2022/01/slow-cooker-hero-95e693e.jpg?quality=90&resize=556,505',
        'Raw':
            'https://cathe.com/wp-content/uploads/2017/11/shutterstock_400298848.jpg',
        'Smoked':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyMLtsfBWQSh0dH4Kdy89Ohi2twYe8TVEs5EKRpmylzy2B3gkVUzH23TORaKxIunkzNdg&usqp=CAU',
        'Blanched':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUe_Xvz8kkGkj24mjOIrVdkGHow65KOaRKQ9a_2sIExhWVpdrrAhstcyWyxmgXO6h1MgQ&usqp=CAU',
        'Broiled':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-kM_rdyYOUhbNLSN-4fOlUQTsq5LraDfPtSomuXjx4uh17VZyicg7HFtTKOPNxlbTTAg&usqp=CAU',
        'Pressure-cooked':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoAAtkXa4K5leBdPDEmDuLl7JWyxD0l7prwGIlJ_chR6kmRDQAD7E56lk2Z5WdUn3rEVg&usqp=CAU',
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

      // Apply filters that can be done on Firestore
      if (params.mealTypes != null && params.mealTypes!.isNotEmpty) {
        query = query.where('mealTypes', arrayContainsAny: params.mealTypes);
      }

      // Fetch all recipes (we'll filter them in memory)
      final querySnapshot = await query.get();
      List<RecipeModel> recipes = querySnapshot.docs
          .map((doc) => RecipeModel.fromMap(doc.data() as DataMap))
          .toList();

      // Apply remaining filters in memory
      recipes = recipes.where((recipe) {
        if (params.cuisineTypes != null && params.cuisineTypes!.isNotEmpty) {
          if (!params.cuisineTypes!.contains(recipe.cuisine)) return false;
        }
        if (params.dishTypes != null && params.dishTypes!.isNotEmpty) {
          if (!params.dishTypes!.contains(recipe.dishType)) return false;
        }
        if (params.preparationMethods != null &&
            params.preparationMethods!.isNotEmpty) {
          if (!params.preparationMethods!.contains(recipe.preparationMethod))
            return false;
        }
        if (params.spiceLevels != null && params.spiceLevels!.isNotEmpty) {
          if (!params.spiceLevels!.contains(recipe.spiceLevel)) return false;
        }
        if (params.servingSizes != null && params.servingSizes!.isNotEmpty) {
          if (!params.servingSizes!.contains(recipe.servingSize)) return false;
        }
        return true;
      }).toList();

      return recipes;
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
  Future<List<String>> toggleFavoriteRecipe(
      String userId, String recipeId) async {
    try {
      final userRef = _cloudStoreClient.collection('users').doc(userId);

      List<String> updatedFavorites =
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
        return favorites;
      });

      return updatedFavorites;
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
      // Add feedback to the feedback collection
      final feedbackRef =
          await _cloudStoreClient.collection('feedback').add(feedback.toMap());

      // Update the recipe's rating, rating count, and add feedback to the recipe
      final recipeRef =
          _cloudStoreClient.collection('recipes').doc(feedback.recipeId);
      await _cloudStoreClient.runTransaction((transaction) async {
        final recipeDoc = await transaction.get(recipeRef);
        if (recipeDoc.exists) {
          final currentRating = recipeDoc.data()!['rating'] as double? ?? 0.0;
          final currentCount = recipeDoc.data()!['ratingCount'] as int? ?? 0;
          final currentFeedback = List<Map<String, dynamic>>.from(
              recipeDoc.data()!['feedback'] as List? ?? []);

          final newCount = currentCount + 1;
          final newRating =
              ((currentRating * currentCount) + feedback.rating) / newCount;

          // Add new feedback to the list
          currentFeedback.add({
            ...feedback.toMap(),
            'id': feedbackRef.id, // Use the ID from the feedback collection
          });

          transaction.update(recipeRef, {
            'rating': newRating,
            'ratingCount': newCount,
            'feedback': currentFeedback,
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
