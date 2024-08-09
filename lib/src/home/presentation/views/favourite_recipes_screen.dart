import 'package:afrosine/core/common/app/providers/user_provider.dart';
import 'package:afrosine/src/home/presentation/widgets/recipe_list_item.dart';
import 'package:afrosine/src/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteRecipesScreen extends StatelessWidget {
  static const routeName = '/favorite-recipes';

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserProvider>().user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Recipes'),
      ),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state is RecipeInitial) {
            context
                .read<RecipeBloc>()
                .add(GetFavoriteRecipesEvent(userId: userId!));
            return Center(child: CircularProgressIndicator());
          } else if (state is RecipesLoaded) {
            final favoriteRecipes = state.recipes;
            if (favoriteRecipes.isEmpty) {
              return Center(child: Text('No favorite recipes yet'));
            }
            return ListView.builder(
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                return RecipeListItem(recipe: favoriteRecipes[index]);
              },
            );
          } else if (state is RecipeError) {
            return Center(child: Text(state.message));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
