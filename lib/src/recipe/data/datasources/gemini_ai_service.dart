// lib/src/recipe/data/datasources/gemini_ai_service.dart

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class GeminiAIService {
  final GenerativeModel _model;

  GeminiAIService({required String apiKey})
      : _model = GenerativeModel(
          model: 'gemini-1.5-pro',
          apiKey: apiKey,
        );

  Future<String> generateRecipe({
    List<XFile>? images,
    required List<String> ingredients,
    List<String>? cuisines,
    List<String>? dietaryRestrictions,
  }) async {
    final prompt = _buildPrompt(ingredients, cuisines, dietaryRestrictions);

    if (images != null && images.isNotEmpty) {
      return await _generateContentFromMultiModal(images, prompt);
    } else {
      return await _generateContentFromText(prompt);
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
    Analyze the provided ingredients and recommend an African recipe. Ensure it only contains real, edible ingredients and adheres to food safety practices.

    Ingredients: ${ingredients.join(', ')}
    ${cuisines != null && cuisines.isNotEmpty ? 'Cuisines: ${cuisines.join(', ')}' : ''}
    ${dietaryRestrictions != null && dietaryRestrictions.isNotEmpty ? 'Dietary Restrictions: ${dietaryRestrictions.join(', ')}' : ''}

    The recipe should be an African dish. Optionally include palm oil, Maggi, salt, or corn flour if they fit the recipe.

    Ensure the recipe belongs to one of these categories:
    - Dish Type: Stews and Soups, Curries, Stir-fries, Salads, Grilled Dishes, Fried Dishes, Baked Dishes, Roasted Dishes, Braised Dishes, Boiled Dishes, Sautéed Dishes, Desserts, Sandwiches, Pasta Dishes, Rice Dishes, Casseroles, Seafood Dishes, Appetizers, Beverages, Breakfast Dishes, Bread and Pastries, Vegetarian Dishes, Vegan Dishes.
    - Preparation Method: Grilled, Fried, Baked, Roasted, Boiled, Sautéed, Steamed, Braised, Poached, Microwaved, Slow-cooked, Raw, Smoked, Blanched, Broiled, Pressure-cooked.
    - Spice Level: Mild, Medium, Spicy, Very Spicy, Extra Spicy.
    - Serving Size: Single-serving, Double-serving, Family size (serves 4), Party size (serves 6+).

    Return the result in JSON format with these keys (all fields are required):
    {
      "recipe_title": "Name of the dish",
      "image_url": "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/African_Dishes.jpg/750px-African_Dishes.jpg",
      "description": "Brief overview of the dish",
      "cuisine_type": "Regional cuisine category (e.g., West African, East African, Central African)",
      "dish_type": "Type of dish (e.g., Stews and Soups, Curries, Stir-fries)",
      "preparation_method": "How the dish is prepared (e.g., Grilled, Fried, Roasted)",
      "spice_level": "Spiciness of the dish (e.g., Mild, Very Spicy)",
      "serving_size": "How many people the recipe serves (e.g., Single-serving, Family size, Party size)",
      "meal_types": ["Categorize the recipe as Breakfast, Lunch, or Dinner"],
      "ingredients": [
        {"name": "Ingredient name", "quantity": "Amount", "unit": "Measurement unit"}
      ],
      "instructions": ["Step 1", "Step 2", "Step 3"],
      "serving_suggestions": "How the dish is typically served",
      "nutritional_content": "The nutritional content per serving"
    }

    Ensure all fields are filled with appropriate values, using placeholder text if necessary.
    ''';

    return basePrompt;
  }

  // String _buildPrompt(List<String> ingredients, List<String>? cuisines,
  //     List<String>? dietaryRestrictions) {
  //   final basePrompt = '''
  //   Analyze the provided ingredients or image and recommend a recipe. Ensure it only contains real, edible ingredients and adheres to food safety practices.
  //
  //   Ingredients: ${ingredients.join(', ')}
  //   ${cuisines != null && cuisines.isNotEmpty ? 'Cuisines: ${cuisines.join(', ')}' : ''}
  //   ${dietaryRestrictions != null && dietaryRestrictions.isNotEmpty ? 'Dietary Restrictions: ${dietaryRestrictions.join(', ')}' : ''}
  //
  //   The recipe should be an African dish. Optionally include palm oil, Maggi, salt, or corn flour if they fit the recipe.
  //
  //   Ensure the recipe belongs to one of these categories:
  //   - Dish Type: Stews and Soups, Curries, Stir-fries, Salads, Grilled Dishes, Fried Dishes, Baked Dishes, Roasted Dishes, Braised Dishes, Boiled Dishes, Sautéed Dishes, Desserts, Sandwiches, Pasta Dishes, Rice Dishes, Casseroles, Seafood Dishes, Appetizers, Beverages, Breakfast Dishes, Bread and Pastries, Vegetarian Dishes, Vegan Dishes.
  //   - Preparation Method: Grilled, Fried, Baked, Roasted, Boiled, Sautéed, Steamed, Braised, Poached, Microwaved, Slow-cooked, Raw, Smoked, Blanched, Broiled, Pressure-cooked.
  //   - Spice Level: Mild, Medium, Spicy, Very Spicy, Extra Spicy.
  //   - Serving Size: Single-serving, Double-serving, Family size (serves 4), Party size (serves 6+).
  //
  //   Return the result in JSON format with these keys:
  //   - recipe_title: The name of the dish.
  //   - image_url: "placeholder_image_url"
  //   - description: A brief overview of the dish.
  //   - cuisine_type: The regional cuisine category (e.g., West African, East African, Central African).
  //   - dish_type: The type of dish (e.g., Stews and Soups, Curries, Stir-fries).
  //   - preparation_method: How the dish is prepared (e.g., Grilled, Fried, Roasted).
  //   - spice_level: The spiciness of the dish (e.g., Mild, Very Spicy).
  //   - serving_size: How many people the recipe serves (e.g., Single-serving, Family size, Party size).
  //   - meal_types: Categorize the recipe as Breakfast, Lunch, or Dinner.
  //   - ingredients: A detailed list of ingredients with quantities and units.
  //   - instructions: Step-by-step directions for preparing the dish.
  //   - serving_suggestions: How the dish is typically served.
  //   - nutritional_content: The nutritional content per serving.
  //
  //   Provide sample responses for cuisine types, dish types, preparation methods, and spice levels to ensure accurate categorization.
  //   ''';
  //
  //   return basePrompt;
  // }
}
