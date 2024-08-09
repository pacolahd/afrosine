import 'package:afrosine/src/home/presentation/widgets/recipe_list_item.dart';
import 'package:afrosine/src/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecipeSearchScreen extends StatefulWidget {
  const RecipeSearchScreen({super.key});

  static const routeName = '/recipe-search';
  @override
  _RecipeSearchScreenState createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      context
          .read<RecipeBloc>()
          .add(SearchRecipesEvent(_searchController.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search recipes...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state is RecipesLoaded && state.recipes.isNotEmpty) {
            return ListView.builder(
              itemCount: state.recipes.length,
              itemBuilder: (context, index) {
                return RecipeListItem(recipe: state.recipes[index]);
              },
            );
          } else if (state is RecipesLoaded && state.recipes.isEmpty) {
            return const Center(child: Text('No recipes found'));
          } else if (state is RecipeError) {
            return Center(child: Text(state.message));
          } else if (state is RecipeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Search something'));
        },
      ),
    );
  }
}
