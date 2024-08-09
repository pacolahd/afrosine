// lib/src/recipe/presentation/views/recipe_details_screen.dart

import 'package:afrosine/core/common/app/providers/user_provider.dart';
import 'package:afrosine/src/recipe/domain/entities/recipe.dart';
import 'package:afrosine/src/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecipeDetailsScreen extends StatelessWidget {
  static const routeName = '/recipe-details';
  final Recipe recipe;

  const RecipeDetailsScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecipeBloc, RecipeState>(
      listener: (context, state) {
        if (state is RecipeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(recipe.name),
          actions: [
            BlocBuilder<RecipeBloc, RecipeState>(
              buildWhen: (previous, current) =>
                  current is FavoriteToggled ||
                  current is FavoriteRecipesLoaded,
              builder: (context, state) {
                final userId = context.read<UserProvider>().user?.uid;
                final isFavorite = context.select((RecipeBloc bloc) =>
                    bloc.state is FavoriteRecipesLoaded
                        ? (bloc.state as FavoriteRecipesLoaded)
                            .favoriteRecipeIds
                            .contains(recipe.id)
                        : false);

                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: () {
                    if (userId != null) {
                      context.read<RecipeBloc>().add(
                            ToggleFavoriteRecipeEvent(
                              userId: userId,
                              recipeId: recipe.id,
                            ),
                          );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please log in to favorite recipes'),
                        ),
                      );
                    }
                  },
                );
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
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      recipe.description,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    SizedBox(height: 16),
                    _buildInfoSection('Cuisine', recipe.cuisine),
                    _buildInfoSection('Dish Type', recipe.dishType),
                    _buildInfoSection(
                        'Preparation Method', recipe.preparationMethod),
                    _buildInfoSection('Spice Level', recipe.spiceLevel),
                    _buildInfoSection('Serving Size', recipe.servingSize),
                    _buildInfoSection(
                        'Meal Types', recipe.mealTypes.join(', ')),
                    SizedBox(height: 16),
                    Text(
                      'Ingredients',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    ...recipe.ingredients.map((ingredient) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                              '• ${ingredient.quantity} ${ingredient.unit} ${ingredient.name}'),
                        )),
                    SizedBox(height: 16),
                    Text(
                      'Instructions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    ...recipe.instructions
                        .asMap()
                        .entries
                        .map((entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text('${entry.key + 1}. ${entry.value}'),
                            )),
                    SizedBox(height: 16),
                    Text(
                      'Serving Suggestions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Text(recipe.servingSuggestions),
                    SizedBox(height: 16),
                    Text(
                      'Nutritional Content',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Text(recipe.nutritionalContent),
                    SizedBox(height: 24),
                    if (recipe.rating > 0)
                      Row(
                        children: [
                          Text('Rating: '),
                          ...List.generate(
                              5,
                              (index) => Icon(
                                    index < recipe.rating.round()
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                  )),
                          SizedBox(width: 8),
                          Text('(${recipe.ratingCount} reviews)'),
                        ],
                      ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to feedback screen or show feedback dialog
                      },
                      child: Text('Leave Feedback'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text('$title: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(content),
        ],
      ),
    );
  }
}
