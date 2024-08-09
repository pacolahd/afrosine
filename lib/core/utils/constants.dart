import 'package:afrosine/src/recipe/data/models/feedback_model.dart';
import 'package:afrosine/src/recipe/data/models/recipe_model.dart';
import 'package:afrosine/src/recipe/domain/entities/ingredient.dart';

const geminiApiKey = 'AIzaSyARfdRXEKmACctFSTMs08t_pMIIYIh4KQM';

const kDefaultAvatar =
    'https://images.freeimages.com/fic/images/icons/573/must_have/256/user.png';
const defaultFoodImage =
    'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/African_Dishes.jpg/750px-African_Dishes.jpg';

const String TABLE_RECIPES = 'recipes';
const String FIELD_MEAL_TYPES = 'mealTypes';
const String FIELD_CUISINE = 'cuisine';
const String FIELD_DISH_TYPE = 'dishType';
const String FIELD_PREPARATION_METHOD = 'preparationMethod';
const String FIELD_SPICE_LEVEL = 'spiceLevel';
const String FIELD_SERVING_SIZE = 'servingSize';
const String FIELD_INGREDIENTS = 'ingredients';
const String FIELD_INSTRUCTIONS = 'instructions';
const String FIELD_FEEDBACK = 'feedback';
const String FIELD_IS_FAVORITE = 'isFavorite';
const String FIELD_RATING = 'rating';
const String FIELD_RATING_COUNT = 'ratingCount';

// lib/src/recipe/constants/recipe_constants.dart

class RecipeConstants {
  static const List<String> dishTypes = [
    'Stews and Soups',
    'Curries',
    'Stir-fries',
    'Salads',
    'Grilled Dishes',
    'Fried Dishes',
    'Baked Dishes',
    'Roasted Dishes',
    'Braised Dishes',
    'Boiled Dishes',
    'Sautéed Dishes',
    'Desserts',
    'Sandwiches',
    'Pasta Dishes',
    'Rice Dishes',
    'Casseroles',
    'Seafood Dishes',
    'Appetizers',
    'Beverages',
    'Breakfast Dishes',
    'Bread and Pastries',
    'Vegetarian Dishes',
    'Vegan Dishes'
  ];

  static const List<String> preparationMethods = [
    'Grilled',
    'Fried',
    'Baked',
    'Roasted',
    'Boiled',
    'Sautéed',
    'Steamed',
    'Braised',
    'Poached',
    'Microwaved',
    'Slow-cooked',
    'Raw',
    'Smoked',
    'Blanched',
    'Broiled',
    'Pressure-cooked'
  ];

  static const List<String> cuisineTypes = [
    'West African',
    'East African',
    'North African',
    'South African',
    'Central African'
  ];

  static const List<String> spiceLevels = [
    'Mild',
    'Medium',
    'Spicy',
    'Very Spicy',
    'Extra Spicy'
  ];

  static const List<String> servingSizes = [
    'Single-serving',
    'Double-serving',
    'Family size (serves 4)',
    'Party size (serves 6+)'
  ];

  static const List<String> mealTypes = ['Breakfast', 'Lunch', 'Dinner'];
}

List<RecipeModel> dummyRecipes() {
  return [
    RecipeModel(
      id: '5',
      name: 'Grilled Salmon',
      description: 'Salmon fillets grilled with a lemon dill marinade.',
      imageUrl: defaultFoodImage,
      ingredients: const [
        Ingredient(name: 'Salmon Fillets', quantity: '4', unit: 'pieces'),
        Ingredient(name: 'Lemon', quantity: '1', unit: 'piece'),
        Ingredient(name: 'Dill', quantity: '2 tbsp', unit: 'tbsp'),
        Ingredient(name: 'Olive Oil', quantity: '2 tbsp', unit: 'tbsp'),
        Ingredient(name: 'Salt', quantity: '1 tsp', unit: 'tsp'),
        Ingredient(name: 'Pepper', quantity: '1/2 tsp', unit: 'tsp'),
      ],
      instructions: const [
        'Marinate salmon fillets in lemon juice, dill, olive oil, salt, and pepper.',
        'Grill over medium heat for 4-5 minutes per side, or until cooked through.'
      ],
      cuisine: 'Mediterranean',
      dishType: 'Grilled',
      preparationMethod: 'Grilled',
      spiceLevel: 'Mild',
      servingSize: '4 servings',
      mealTypes: const ['Dinner'],
      rating: 4.8,
      ratingCount: 10,
      feedback: [
        FeedbackModel(
          userId: 'user5',
          recipeId: '5',
          rating: 5.0,
          comment: 'Perfectly cooked! The marinade added great flavor.',
          id: '3',
          createdAt: DateTime.now(),
        ),
      ],
      nutritionalContent: '',
      servingSuggestions: '',
    ),
  ];
}
