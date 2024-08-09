// lib/src/recipe/presentation/views/recipe_finder_screen.dart

import 'package:afrosine/src/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:afrosine/src/recipe/presentation/views/recipe_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class RecipeFinderScreen extends StatefulWidget {
  @override
  _RecipeFinderScreenState createState() => _RecipeFinderScreenState();
}

class _RecipeFinderScreenState extends State<RecipeFinderScreen> {
  List<XFile>? _images;
  List<String> _selectedStapleIngredients = [];
  final TextEditingController _additionalIngredientsController =
      TextEditingController();
  List<String> _selectedCuisines = [];
  List<String> _selectedDietaryRestrictions = [];

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

  final List<String> _cuisines = [
    'West African',
    'East African',
    'North African',
    'South African',
    'Central African'
  ];

  final List<String> _dietaryRestrictions = [
    'Vegetarian',
    'Vegan',
    'Gluten-free',
    'Dairy-free',
    'Nut-free'
  ];

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
            debugPrint(state.message);
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
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 16),
                Text(
                  'Enter or take a picture of the ingredients you have on hand, and we\'ll find delicious recipes you can make. Add more ingredients to your list and refine your search. When you\'re ready, click \'Find Recipes\' to discover the options that match your ingredients!',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _getImage,
                  child: Text('Upload photo'),
                ),
                if (_images != null && _images!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Image uploaded: ${_images!.first.name}'),
                  ),
                SizedBox(height: 16),
                Text(
                  'Staple ingredients',
                  style: Theme.of(context).textTheme.titleMedium,
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
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextField(
                  controller: _additionalIngredientsController,
                  decoration: InputDecoration(
                    hintText: 'Enter ingredients, separated by commas',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Cuisines',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Wrap(
                  spacing: 8,
                  children: _cuisines.map((cuisine) {
                    return FilterChip(
                      label: Text(cuisine),
                      selected: _selectedCuisines.contains(cuisine),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedCuisines.add(cuisine);
                          } else {
                            _selectedCuisines.remove(cuisine);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                Text(
                  'Dietary Restrictions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Wrap(
                  spacing: 8,
                  children: _dietaryRestrictions.map((restriction) {
                    return FilterChip(
                      label: Text(restriction),
                      selected:
                          _selectedDietaryRestrictions.contains(restriction),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedDietaryRestrictions.add(restriction);
                          } else {
                            _selectedDietaryRestrictions.remove(restriction);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _findRecipe,
                    child: Text('Find Recipe'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                  ),
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

  Future<void> _getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _images = [image];
      });
    }
  }

  void _findRecipe() {
    final ingredients = [
      ..._selectedStapleIngredients,
      ..._additionalIngredientsController.text.split(',').map((e) => e.trim()),
    ];
    context.read<RecipeBloc>().add(
          GenerateRecipeEvent(
            images: _images,
            ingredients: ingredients,
            cuisines: _selectedCuisines.isNotEmpty ? _selectedCuisines : null,
            dietaryRestrictions: _selectedDietaryRestrictions.isNotEmpty
                ? _selectedDietaryRestrictions
                : null,
          ),
        );
  }

  @override
  void dispose() {
    _additionalIngredientsController.dispose();
    super.dispose();
  }
}
