import 'package:afrosine/core/resources/theme/app_colors.dart';
import 'package:afrosine/src/recipe/domain/usecases/get_recipes.dart';
import 'package:afrosine/src/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final Map<String, List<String>> _filters = {
    'Dish type': ['Stews and soups', 'Curries', 'Stir-fries'],
    'Preparation method': ['Grilled', 'Fried', 'Roasted'],
    'Cuisine type': [
      'West African',
      'East African',
      'Central African',
      'South African',
      'North African'
    ],
    'Spice level': ['Mild', 'Medium', 'Spicy', 'Very spicy'],
    'Serving size': ['Single-serving', 'Family size', 'Party size'],
  };

  final Map<String, List<String>> _selectedFilters = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: const Text('Reset'),
                onPressed: () {
                  setState(() {
                    _selectedFilters.clear();
                  });
                },
              ),
              Text(
                'Filters',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                child: const Text('Done'),
                onPressed: () {
                  final params = FilterParams(
                    dishTypes: _selectedFilters['Dish type'],
                    preparationMethods: _selectedFilters['Preparation method'],
                    cuisineTypes: _selectedFilters['Cuisine type'],
                    spiceLevels: _selectedFilters['Spice level'],
                    servingSizes: _selectedFilters['Serving size'],
                  );
                  context.read<RecipeBloc>().add(FilterRecipesEvent(params));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final key = _filters.keys.elementAt(index);
                return _buildFilterSection(key, _filters[key]!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.dark,
                )),
        Wrap(
          spacing: 8,
          children: options.map((option) {
            bool isSelected =
                _selectedFilters[title]?.contains(option) ?? false;
            return FilterChip(
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade400,
                ),
              ),
              // selectedColor: Theme.of(context).colorScheme.primary,
              selectedColor: AppColors.milkyWhite,
              labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : AppColors.dark,
                  ),
              showCheckmark: false,
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedFilters[title] = (_selectedFilters[title] ?? [])
                      ..add(option);
                  } else {
                    _selectedFilters[title]?.remove(option);
                    if (_selectedFilters[title]?.isEmpty ?? false) {
                      _selectedFilters.remove(title);
                    }
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
