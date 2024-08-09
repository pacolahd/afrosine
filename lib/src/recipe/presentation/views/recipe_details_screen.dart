// lib/src/recipe/presentation/views/recipe_details_screen.dart

import 'package:afrosine/src/recipe/domain/entities/recipe.dart';
import 'package:flutter/material.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailsScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: () {
              // TODO: Implement bookmark functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              recipe.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(height: 8),
                  Text(
                    recipe.description,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Ingredients',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 8),
                  ...recipe.ingredients.map((ingredient) => Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                            '• ${ingredient.quantity} ${ingredient.unit} ${ingredient.name}'),
                      )),
                  SizedBox(height: 16),
                  Text(
                    'Preparation',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 8),
                  ...recipe.instructions.asMap().entries.map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text('${entry.key + 1}. ${entry.value}'),
                      )),
                  SizedBox(height: 16),
                  Text(
                    'Additional Information',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 8),
                  Text('Cuisine: ${recipe.cuisine}'),
                  Text('Dish Type: ${recipe.dishType}'),
                  Text('Preparation Method: ${recipe.preparationMethod}'),
                  Text('Spice Level: ${recipe.spiceLevel}'),
                  Text('Serving Size: ${recipe.servingSize}'),
                  Text('Meal Types: ${recipe.mealTypes.join(", ")}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
