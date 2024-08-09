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

List<RecipeModel> dummyRecipes() {
  return [
    const RecipeModel(
      id: '1',
      name: 'Pancakes',
      description: 'Fluffy pancakes served with syrup and fresh fruit.',
      imageUrl: defaultFoodImage,
      ingredients: [
        Ingredient(name: 'Flour', quantity: '1 cup', unit: 'cup'),
        Ingredient(name: 'Milk', quantity: '1 cup', unit: 'cup'),
        Ingredient(name: 'Eggs', quantity: '2', unit: 'pieces'),
        Ingredient(name: 'Baking Powder', quantity: '2 tsp', unit: 'tsp'),
        Ingredient(name: 'Butter', quantity: '2 tbsp', unit: 'tbsp'),
      ],
      instructions: [
        'Mix all ingredients until smooth.',
        'Heat a non-stick skillet over medium heat.',
        'Pour batter into skillet and cook until bubbles form, then flip and cook until golden brown.'
      ],
      cuisine: 'American',
      dishType: 'Breakfast',
      preparationMethod: 'Grilled',
      spiceLevel: 'Mild',
      servingSize: '4 servings',
      mealTypes: ['Breakfast'],
      rating: 4.7,
      ratingCount: 12,
      feedback: [],
    ),
    RecipeModel(
      id: '2',
      name: 'Chicken Curry',
      description:
          'A flavorful curry with tender chicken pieces simmered in a spicy sauce.',
      imageUrl: defaultFoodImage,
      ingredients: const [
        Ingredient(name: 'Chicken Breast', quantity: '500g', unit: 'grams'),
        Ingredient(name: 'Onion', quantity: '1', unit: 'piece'),
        Ingredient(name: 'Garlic', quantity: '3 cloves', unit: 'cloves'),
        Ingredient(name: 'Curry Powder', quantity: '2 tbsp', unit: 'tbsp'),
        Ingredient(name: 'Tomatoes', quantity: '2', unit: 'pieces'),
        Ingredient(name: 'Coconut Milk', quantity: '1 can', unit: 'can'),
      ],
      instructions: const [
        'Sauté onions and garlic until soft.',
        'Add chicken pieces and cook until browned.',
        'Stir in curry powder and tomatoes, then add coconut milk.',
        'Simmer until chicken is cooked through and sauce is thickened.'
      ],
      cuisine: 'Indian',
      dishType: 'Curry',
      preparationMethod: 'Simmered',
      spiceLevel: 'Medium',
      servingSize: '4 servings',
      mealTypes: const ['Lunch'],
      rating: 4.5,
      ratingCount: 20,
      feedback: [
        FeedbackModel(
            userId: 'user3',
            recipeId: '2',
            rating: 4.8,
            comment: 'Absolutely delicious! The curry was perfectly spiced.',
            createdAt: DateTime.now(),
            id: '9'),
      ],
    ),
    RecipeModel(
      id: '3',
      name: 'Beef Stew',
      description: 'Hearty beef stew with vegetables and rich gravy.',
      imageUrl: defaultFoodImage,
      ingredients: const [
        Ingredient(name: 'Beef Chuck', quantity: '1 kg', unit: 'kilogram'),
        Ingredient(name: 'Carrots', quantity: '3', unit: 'pieces'),
        Ingredient(name: 'Potatoes', quantity: '4', unit: 'pieces'),
        Ingredient(name: 'Onions', quantity: '2', unit: 'pieces'),
        Ingredient(name: 'Beef Broth', quantity: '4 cups', unit: 'cups'),
        Ingredient(name: 'Tomato Paste', quantity: '2 tbsp', unit: 'tbsp'),
      ],
      instructions: const [
        'Brown beef chunks in a pot.',
        'Add onions and cook until soft.',
        'Stir in carrots, potatoes, and tomato paste.',
        'Pour in beef broth and simmer until beef is tender and vegetables are cooked.'
      ],
      cuisine: 'Western',
      dishType: 'Stew',
      preparationMethod: 'Simmered',
      spiceLevel: 'Mild',
      servingSize: '6 servings',
      mealTypes: const ['Dinner'],
      rating: 4.6,
      ratingCount: 15,
      feedback: [
        FeedbackModel(
          userId: 'user4',
          recipeId: '3',
          rating: 4.9,
          comment: 'Comfort food at its best! Rich and satisfying.',
          id: '8',
          createdAt: DateTime.now(),
        ),
      ],
    ),
    const RecipeModel(
      id: '4',
      name: 'Vegetable Stir-Fry',
      description: 'Quick and easy vegetable stir-fry with a tangy sauce.',
      imageUrl: defaultFoodImage,
      ingredients: [
        Ingredient(name: 'Bell Peppers', quantity: '2', unit: 'pieces'),
        Ingredient(name: 'Broccoli', quantity: '1 cup', unit: 'cup'),
        Ingredient(name: 'Carrots', quantity: '2', unit: 'pieces'),
        Ingredient(name: 'Soy Sauce', quantity: '3 tbsp', unit: 'tbsp'),
        Ingredient(name: 'Ginger', quantity: '1 tbsp', unit: 'tbsp'),
        Ingredient(name: 'Garlic', quantity: '2 cloves', unit: 'cloves'),
      ],
      instructions: [
        'Heat oil in a pan and add garlic and ginger.',
        'Add vegetables and stir-fry until crisp-tender.',
        'Pour in soy sauce and cook for another 2 minutes.'
      ],
      cuisine: 'Chinese',
      dishType: 'Stir-Fry',
      preparationMethod: 'Stir-Fried',
      spiceLevel: 'Mild',
      servingSize: '4 servings',
      mealTypes: ['Lunch'],
      rating: 4.3,
      ratingCount: 8,
      feedback: [],
    ),
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
    ),
  ];
}
