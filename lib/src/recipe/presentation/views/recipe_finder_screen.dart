// lib/src/recipe/presentation/views/recipe_finder_screen.dart

import 'package:afrosine/src/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:afrosine/src/recipe/presentation/views/recipe_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecipeFinderScreen extends StatefulWidget {
  @override
  _RecipeFinderScreenState createState() => _RecipeFinderScreenState();
}

class _RecipeFinderScreenState extends State<RecipeFinderScreen> {
  final List<String> _stapleIngredients = [
    'Salt',
    'Black pepper',
    'Flour',
    'Oil',
    'Butter',
    'Vinegar',
    'Honey',
    'Basil',
    'Oregano'
  ];
  List<String> _selectedStapleIngredients = [];
  final TextEditingController _additionalIngredientsController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Find Recipes with Your Ingredients')),
      body: BlocConsumer<RecipeBloc, RecipeState>(
        listener: (context, state) {
          if (state is RecipeGenerated) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RecipeDetailsScreen(recipe: state.recipe),
              ),
            );
          } else if (state is RecipeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find Recipes with Your Ingredients',
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(height: 16),
                Text(
                  'Enter or take a picture of the ingredients you have on hand, and we\'ll find delicious recipes you can make. Add more ingredients to your list and refine your search. When you\'re ready, click \'Find Recipes\' to discover the options that match your ingredients!',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement image upload functionality
                  },
                  child: Text('Upload photo'),
                ),
                SizedBox(height: 16),
                Text(
                  'Staple ingredients',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Wrap(
                  spacing: 8,
                  children: _stapleIngredients.map((ingredient) {
                    return FilterChip(
                      label: Text(ingredient),
                      selected: _selectedStapleIngredients.contains(ingredient),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedStapleIngredients.add(ingredient);
                          } else {
                            _selectedStapleIngredients.remove(ingredient);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                Text(
                  'List any additional ingredients',
                  style: Theme.of(context).textTheme.headline6,
                ),
                TextField(
                  controller: _additionalIngredientsController,
                  decoration: InputDecoration(
                    hintText: 'Enter ingredients',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement apply filters functionality
                  },
                  child: Text('Apply filters'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final ingredients = [
                      ..._selectedStapleIngredients,
                      ..._additionalIngredientsController.text
                          .split(',')
                          .map((e) => e.trim()),
                    ];
                    context.read<RecipeBloc>().add(
                          GenerateRecipeEvent(
                            ingredients: ingredients,
                            country: 'Kenya', // You can make this configurable
                          ),
                        );
                  },
                  child: Text('Find Recipe'),
                ),
                if (state is RecipeLoading)
                  Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _additionalIngredientsController.dispose();
    super.dispose();
  }
}
