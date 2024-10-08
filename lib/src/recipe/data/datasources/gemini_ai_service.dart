// lib/src/recipe/data/datasources/gemini_ai_service.dart

import 'dart:convert';

import 'package:afrosine/core/utils/constants.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class GeminiAIService {
  GeminiAIService({required String apiKey})
      : _model = GenerativeModel(
          model: 'gemini-1.5-pro',
          apiKey: apiKey,
        );
  final GenerativeModel _model;

  Future<String> generateRecipes({
    List<XFile>? images,
    required List<String> ingredients,
    List<String>? cuisines,
    List<String>? dietaryRestrictions,
  }) async {
    final prompt = _buildPrompt(ingredients, cuisines, dietaryRestrictions);

    String response;
    if (images != null && images.isNotEmpty) {
      response = await _generateContentFromMultiModal(images, prompt);
    } else {
      response = await _generateContentFromText(prompt);
    }

    // Clean and format the response
    String cleanedResponse = _cleanAndFormatResponse(response);

    return cleanedResponse;
  }

  String _cleanAndFormatResponse(String response) {
    // Remove any leading or trailing whitespace
    response = response.trim();

    // If the response doesn't start with '[', add it
    if (!response.startsWith('[')) {
      response = '[$response';
    }

    // If the response doesn't end with ']', add it
    if (!response.endsWith(']')) {
      response = '$response]';
    }

    // Try to parse the JSON to ensure it's valid
    try {
      json.decode(response);
      return response;
    } catch (e) {
      // If parsing fails, attempt to fix common issues
      response = response.replaceAll(RegExp(r'},\s*]'),
          '}]'); // Remove trailing comma before closing bracket
      response = response.replaceAll(
          RegExp(r',\s*}'), '}'); // Remove trailing comma in objects

      // Try parsing again
      try {
        json.decode(response);
        return response;
      } catch (e) {
        throw FormatException(
            'Unable to format AI response into valid JSON: $response');
      }
    }
  }

  Future<String> _generateContentFromMultiModal(
      List<XFile> images, String prompt) async {
    final mainText = TextPart(prompt);
    final imagesParts = <DataPart>[];
    for (var f in images) {
      final bytes = await f.readAsBytes();
      imagesParts.add(DataPart('image/jpeg', bytes));
    }
    final input = [
      Content.multi([...imagesParts, mainText])
    ];
    final response = await _model.generateContent(input);
    return _extractJsonFromResponse(response.text ?? '');
  }

  Future<String> _generateContentFromText(String prompt) async {
    final response = await _model.generateContent([Content.text(prompt)]);
    return _extractJsonFromResponse(response.text ?? '');
  }

  String _extractJsonFromResponse(String response) {
    // Remove any markdown code block indicators
    final cleanResponse =
        response.replaceAll(RegExp(r'```json|```'), '').trim();

    // Find the first { and the last } to extract the JSON object
    final startIndex = cleanResponse.indexOf('{');
    final endIndex = cleanResponse.lastIndexOf('}');

    if (startIndex != -1 && endIndex != -1 && startIndex < endIndex) {
      return cleanResponse.substring(startIndex, endIndex + 1);
    } else {
      throw FormatException('Invalid JSON response from Gemini AI');
    }
  }

  String _buildPrompt(List<String> ingredients, List<String>? cuisines,
      List<String>? dietaryRestrictions) {
    final basePrompt = '''
    Analyze the provided ingredients and recommend 3 different African recipes. Ensure they only contain real, edible ingredients and adhere to food safety practices.

    Ingredients: ${ingredients.join(', ')}
    ${cuisines != null && cuisines.isNotEmpty ? 'Cuisines: ${cuisines.join(', ')}' : ''}
    ${dietaryRestrictions != null && dietaryRestrictions.isNotEmpty ? 'Dietary Restrictions: ${dietaryRestrictions.join(', ')}' : ''}

    The recipes should be African dishes. Optionally include palm oil, Maggi, salt, or corn flour if they fit the recipes.

    Ensure each recipe belongs to these categories:
    - Dish Type: ${RecipeConstants.dishTypes.join(', ')}
    - Preparation Method: ${RecipeConstants.preparationMethods.join(', ')}
    - Cuisine Type: ${RecipeConstants.cuisineTypes.join(', ')}
    - Spice Level: ${RecipeConstants.spiceLevels.join(', ')}
    - Serving Size: ${RecipeConstants.servingSizes.join(', ')}
    - Meal Types: ${RecipeConstants.mealTypes.join(', ')}

    Return the result as a JSON array containing 3 recipe objects with these keys (all fields are required):
    [
      {
        "name": "Name of the dish",
        "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/African_Dishes.jpg/750px-African_Dishes.jpg",
        "description": "Brief overview of the dish",
        "cuisine": "One of the cuisine types listed above",
        "dishType": "One of the dish types listed above",
        "preparationMethod": "One of the preparation methods listed above",
        "spiceLevel": "One of the spice levels listed above",
        "servingSize": "One of the serving sizes listed above",
        "mealTypes": ["One or more of the meal types listed above"],
        "ingredients": [
          {"name": "Ingredient name", "quantity": "Amount", "unit": "Measurement unit"}
        ],
        "instructions": ["Step 1", "Step 2", "Step 3"],
        "servingSuggestions": "How the dish is typically served",
        "nutritionalContent": "The nutritional content per serving"
      },
      // ... two more recipe objects
    ]

    Ensure all fields are filled with appropriate values, using only the options provided in the lists above.
    ''';

    return basePrompt;
  }

  // String _buildPrompt(List<String> ingredients, List<String>? cuisines,
  //     List<String>? dietaryRestrictions) {
  //   final basePrompt = '''
  //   Analyze the provided ingredients and recommend 3 different African recipes. Ensure they only contain real, edible ingredients and adhere to food safety practices.
  //
  //   Ingredients: ${ingredients.join(', ')}
  //   ${cuisines != null && cuisines.isNotEmpty ? 'Cuisines: ${cuisines.join(', ')}' : ''}
  //   ${dietaryRestrictions != null && dietaryRestrictions.isNotEmpty ? 'Dietary Restrictions: ${dietaryRestrictions.join(', ')}' : ''}
  //
  //   The recipes should be African dishes. Optionally include palm oil, Maggi, salt, or corn flour if they fit the recipes.
  //
  //   Ensure each recipe belongs to one of these categories:
  //   - Dish Type: Stews and Soups, Curries, Stir-fries, Salads, Grilled Dishes, Fried Dishes, Baked Dishes, Roasted Dishes, Braised Dishes, Boiled Dishes, Sautéed Dishes, Desserts, Sandwiches, Pasta Dishes, Rice Dishes, Casseroles, Seafood Dishes, Appetizers, Beverages, Breakfast Dishes, Bread and Pastries, Vegetarian Dishes, Vegan Dishes.
  //   - Preparation Method: Grilled, Fried, Baked, Roasted, Boiled, Sautéed, Steamed, Braised, Poached, Microwaved, Slow-cooked, Raw, Smoked, Blanched, Broiled, Pressure-cooked.
  //   - Spice Level: Mild, Medium, Spicy, Very Spicy, Extra Spicy.
  //   - Serving Size: Single-serving, Double-serving, Family size (serves 4), Party size (serves 6+).
  //
  //   Return the result as a JSON array containing 3 recipe objects with these keys (all fields are required):
  //   [
  //     {
  //       "name": "Name of the dish",
  //       "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/African_Dishes.jpg/750px-African_Dishes.jpg",
  //       "description": "Brief overview of the dish",
  //       "cuisine": "Regional cuisine category (e.g., West African, East African, Central African)",
  //       "dishType": "Type of dish (e.g., Stews and Soups, Curries, Stir-fries)",
  //       "preparationMethod": "How the dish is prepared (e.g., Grilled, Fried, Roasted)",
  //       "spiceLevel": "Spiciness of the dish (e.g., Mild, Very Spicy)",
  //       "servingSize": "How many people the recipe serves (e.g., Single-serving, Family size, Party size)",
  //       "mealTypes": ["Categorize the recipe as Breakfast, Lunch, or Dinner"],
  //       "ingredients": [
  //         {"name": "Ingredient name", "quantity": "Amount", "unit": "Measurement unit"}
  //       ],
  //       "instructions": ["Step 1", "Step 2", "Step 3"],
  //       "servingSuggestions": "How the dish is typically served",
  //       "nutritionalContent": "The nutritional content per serving"
  //     },
  //     // ... two more recipe objects
  //   ]
  //
  //   Ensure all fields are filled with appropriate values, using placeholder text if necessary.
  //   ''';
  //
  //   return basePrompt;
  // }
}
