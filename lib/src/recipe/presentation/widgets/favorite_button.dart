import 'package:afrosine/core/common/app/providers/user_provider.dart';
import 'package:afrosine/src/recipe/domain/entities/recipe.dart';
import 'package:afrosine/src/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteButton extends StatelessWidget {
  final Recipe recipe;

  const FavoriteButton({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecipeBloc, RecipeState>(
      listenWhen: (previous, current) => current is FavoriteToggled,
      listener: (context, state) {
        if (state is FavoriteToggled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Favorites updated')),
          );
        }
      },
      buildWhen: (previous, current) =>
          current is FavoriteRecipesLoaded || current is FavoriteToggled,
      builder: (context, state) {
        final userProvider = context.watch<UserProvider>();
        final isFavorite =
            userProvider.user?.favoriteRecipeIds.contains(recipe.id) ?? false;

        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            if (userProvider.user != null) {
              context.read<RecipeBloc>().add(
                    ToggleFavoriteRecipeEvent(
                      recipeId: recipe.id,
                      userProvider: userProvider,
                    ),
                  );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Please log in to favorite recipes')),
              );
            }
          },
        );
      },
    );
  }
}
