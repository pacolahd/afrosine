// import 'dart:convert';
//
// import 'package:afrosine/core/errors/exceptions.dart';
// import 'package:afrosine/src/recipe/data/datasources/database_helper.dart';
// import 'package:afrosine/src/recipe/data/models/feedback_model.dart';
// import 'package:afrosine/src/recipe/data/models/ingredient_model.dart';
// import 'package:afrosine/src/recipe/data/models/recipe_model.dart';
// import 'package:afrosine/src/recipe/domain/usecases/get_recipes.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:sqflite/sqflite.dart';
//
// abstract class RecipeLocalDataSource {
//   Future<void> cacheRecipes(List<RecipeModel> recipes);
//   Future<List<RecipeModel>> getCachedRecipes();
//   Future<RecipeModel?> getCachedRecipeById(String id);
//   Future<void> updateFavoriteStatus(String recipeId, bool isFavorite);
//   Future<List<String>> getFavoriteRecipeIds();
//   Future<List<RecipeModel>> searchRecipes(String query);
//   Future<List<RecipeModel>> filterRecipes(FilterParams params);
//   Future<void> closeDatabase();
// }
//
// class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
//   // const RecipeLocalDataSourceImpl({
//   //   required Database database,
//   // }) : _database = database;
//   //
//   // final Database _database;
//
//   final DatabaseHelper databaseHelper;
//
//   RecipeLocalDataSourceImpl({required this.databaseHelper});
//
//   Future<Database> get _database => databaseHelper.database;
//
//   static const String TABLE_RECIPES = 'recipes';
//   static const String FIELD_MEAL_TYPES = 'mealTypes';
//   static const String FIELD_CUISINE = 'cuisine';
//   static const String FIELD_DISH_TYPE = 'dishType';
//   static const String FIELD_PREPARATION_METHOD = 'preparationMethod';
//   static const String FIELD_SPICE_LEVEL = 'spiceLevel';
//   static const String FIELD_SERVING_SIZE = 'servingSize';
//   static const String FIELD_INGREDIENTS = 'ingredients';
//   static const String FIELD_INSTRUCTIONS = 'instructions';
//   static const String FIELD_FEEDBACK = 'feedback';
//   static const String FIELD_IS_FAVORITE = 'isFavorite';
//   static const String FIELD_RATING = 'rating';
//   static const String FIELD_RATING_COUNT = 'ratingCount';
//
//   @override
//   Future<void> cacheRecipes(List<RecipeModel> recipes) async {
//     try {
//       final db = await _database;
//       Batch batch = db.batch();
//       for (var recipe in recipes) {
//         var recipeMap = recipe.toMap();
//         recipeMap['ingredients'] = json.encode(
//             recipeMap['ingredients'] is String
//                 ? json.decode(recipeMap['ingredients'] as String)
//                 : recipeMap['ingredients']
//                     .map((i) => i is Map ? i : i.toMap())
//                     .toList());
//
//         recipeMap['instructions'] = json.encode(
//             recipeMap['instructions'] is String
//                 ? json.decode(recipeMap['instructions'] as String)
//                 : recipeMap['instructions']);
//
//         recipeMap['mealTypes'] = json.encode(recipeMap['mealTypes'] is String
//             ? json.decode(recipeMap['mealTypes'] as String)
//             : recipeMap['mealTypes']);
//
//         recipeMap['feedback'] = json.encode(recipeMap['feedback'] is String
//             ? json.decode(recipeMap['feedback'] as String)
//             : recipeMap['feedback']
//                 .map((f) => f is Map ? f : f.toMap())
//                 .toList());
//
//         recipeMap['isFavorite'] = 0;
//         batch.insert(
//           'recipes',
//           recipeMap,
//           conflictAlgorithm: ConflictAlgorithm.replace,
//         );
//       }
//       await batch.commit(noResult: true);
//     } catch (e) {
//       debugPrint('Error caching recipes: $e');
//       rethrow;
//     }
//   }
//
//   @override
//   Future<List<RecipeModel>> getCachedRecipes() async {
//     try {
//       final db = await _database;
//       final List<Map<String, dynamic>> maps = await db.query('recipes');
//       return List.generate(maps.length, (i) {
//         var recipeMap = maps[i];
//         recipeMap['ingredients'] =
//             (json.decode(recipeMap['ingredients'] as String) as List)
//                 .map((i) => IngredientModel.fromMap(i as Map<String, dynamic>))
//                 .toList();
//         recipeMap['instructions'] =
//             json.decode(recipeMap['instructions'] as String) as List<String>;
//         recipeMap['mealTypes'] =
//             json.decode(recipeMap['mealTypes'] as String) as List<String>;
//         recipeMap['feedback'] =
//             (json.decode(recipeMap['feedback'] as String) as List)
//                 .map((f) => FeedbackModel.fromMap(f as Map<String, dynamic>))
//                 .toList();
//         return RecipeModel.fromMap(recipeMap);
//       });
//     } catch (e) {
//       debugPrint('Error getting cached recipes: $e');
//       rethrow;
//     }
//   }
//
//   @override
//   Future<RecipeModel?> getCachedRecipeById(String id) async {
//     try {
//       final db = await _database;
//       final List<Map<String, dynamic>> maps = await db.query(
//         'recipes',
//         where: 'id = ?',
//         whereArgs: [id],
//       );
//       if (maps.isNotEmpty) {
//         var recipeMap = maps.first;
//         recipeMap['ingredients'] =
//             (json.decode(recipeMap['ingredients'] as String) as List)
//                 .map((i) => IngredientModel.fromMap(i as Map<String, dynamic>))
//                 .toList();
//         recipeMap['instructions'] =
//             json.decode(recipeMap['instructions'] as String) as List<String>;
//         recipeMap['mealTypes'] =
//             json.decode(recipeMap['mealTypes'] as String) as List<String>;
//         recipeMap['feedback'] =
//             (json.decode(recipeMap['feedback'] as String) as List)
//                 .map((f) => FeedbackModel.fromMap(f as Map<String, dynamic>))
//                 .toList();
//         return RecipeModel.fromMap(recipeMap);
//       }
//       return null;
//     } catch (e) {
//       debugPrint('Error getting cached recipe by id: $e');
//       rethrow;
//     }
//   }
//
//   @override
//   Future<void> updateFavoriteStatus(String recipeId, bool isFavorite) async {
//     try {
//       final db = await _database;
//       await db.update(
//         'recipes',
//         {'isFavorite': isFavorite ? 1 : 0},
//         where: 'id = ?',
//         whereArgs: [recipeId],
//       );
//     } catch (e) {
//       debugPrint('Error updating favorite status: $e');
//       rethrow;
//     }
//   }
//
//   @override
//   Future<List<String>> getFavoriteRecipeIds() async {
//     try {
//       final db = await _database;
//       final List<Map<String, dynamic>> maps = await db.query(
//         'recipes',
//         columns: ['id'],
//         where: 'isFavorite = ?',
//         whereArgs: [1],
//       );
//       return List.generate(maps.length, (i) => maps[i]['id'] as String);
//     } catch (e) {
//       debugPrint('Error getting favorite recipe ids: $e');
//       rethrow;
//     }
//   }
//
//   @override
//   Future<List<RecipeModel>> searchRecipes(String query) async {
//     try {
//       final db = await _database;
//       final List<Map<String, dynamic>> maps = await db.query(
//         'recipes',
//         where:
//             'name LIKE ? OR description LIKE ? OR cuisine LIKE ? OR dishType LIKE ?',
//         whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%'],
//       );
//       return List.generate(maps.length, (i) {
//         var recipeMap = maps[i];
//         recipeMap['ingredients'] =
//             (json.decode(recipeMap['ingredients'] as String) as List)
//                 .cast<Map<String, dynamic>>();
//         recipeMap['instructions'] =
//             (json.decode(recipeMap['instructions'] as String) as List)
//                 .cast<String>();
//         recipeMap['mealTypes'] =
//             (json.decode(recipeMap['mealTypes'] as String) as List)
//                 .cast<String>();
//         recipeMap['feedback'] =
//             (json.decode(recipeMap['feedback'] as String) as List)
//                 .cast<Map<String, dynamic>>();
//         return RecipeModel.fromMap(recipeMap);
//       });
//     } catch (e) {
//       debugPrint('Error searching recipes: $e');
//       rethrow;
//     }
//   }
//
//   @override
//   Future<List<RecipeModel>> filterRecipes(FilterParams params) async {
//     try {
//       final db = await _database;
//
//       List<String> whereClauses = [];
//       List<dynamic> whereArgs = [];
//
//       void addFilter(String field, List<String>? values, {bool like = false}) {
//         if (values != null && values.isNotEmpty) {
//           List<String> lowerCaseValues =
//               values.map((v) => v.toLowerCase()).toList();
//           if (like) {
//             whereClauses.add(
//                 '(${lowerCaseValues.map((_) => 'LOWER($field) LIKE ?').join(' OR ')})');
//             whereArgs.addAll(lowerCaseValues.map((v) => '%$v%'));
//           } else {
//             whereClauses.add(
//                 'LOWER($field) IN (${lowerCaseValues.map((_) => '?').join(', ')})');
//             whereArgs.addAll(lowerCaseValues);
//           }
//         }
//       }
//
//       addFilter(FIELD_MEAL_TYPES, params.mealTypes, like: true);
//       addFilter(FIELD_CUISINE, params.cuisineTypes);
//       addFilter(FIELD_DISH_TYPE, params.dishTypes);
//       addFilter(FIELD_PREPARATION_METHOD, params.preparationMethods);
//       addFilter(FIELD_SPICE_LEVEL, params.spiceLevels);
//       addFilter(FIELD_SERVING_SIZE, params.servingSizes);
//
//       String whereClause =
//           whereClauses.isEmpty ? '' : whereClauses.join(' AND ');
//
//       // Debugging statements
//       debugPrint('Filter Params: ${params.toJson()}');
//       debugPrint('Where Clause: $whereClause');
//       debugPrint('Where Args: $whereArgs');
//
//       final List<Map<String, dynamic>> maps = await db.query(
//         TABLE_RECIPES,
//         where: whereClause.isEmpty ? null : whereClause,
//         whereArgs: whereArgs.isEmpty ? null : whereArgs,
//       );
//
//       debugPrint('Query Result: $maps');
//
//       return List.generate(maps.length, (i) {
//         var recipeMap = maps[i];
//         recipeMap[FIELD_INGREDIENTS] =
//             (json.decode(recipeMap[FIELD_INGREDIENTS] as String) as List)
//                 .map((i) => IngredientModel.fromMap(i as Map<String, dynamic>))
//                 .toList();
//         recipeMap[FIELD_INSTRUCTIONS] = json
//             .decode(recipeMap[FIELD_INSTRUCTIONS] as String) as List<String>;
//         recipeMap[FIELD_MEAL_TYPES] =
//             json.decode(recipeMap[FIELD_MEAL_TYPES] as String) as List<String>;
//         recipeMap[FIELD_FEEDBACK] =
//             (json.decode(recipeMap[FIELD_FEEDBACK] as String) as List)
//                 .map((f) => FeedbackModel.fromMap(f as Map<String, dynamic>))
//                 .toList();
//         return RecipeModel.fromMap(recipeMap);
//       });
//     } catch (e) {
//       debugPrint('Error filtering recipes: $e');
//       if (e is DatabaseException) {
//         debugPrint('SQLite error ${e.getResultCode()}: ${e}');
//       }
//       throw CacheException(message: 'Failed to filter recipes: $e');
//     }
//   }
//
//   @override
//   Future<void> closeDatabase() {
//     // TODO: implement closeDatabase
//     throw UnimplementedError();
//   }
//
//   // @override
//   // Future<void> closeDatabase() async {
//   //   try {
//   //     await _database.close();
//   //   } catch (e) {
//   //     debugPrint('Error closing database: $e');
//   //     throw CacheException(message: 'Failed to close database: $e');
//   //   }
//   // }
// }
