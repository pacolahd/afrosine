import 'package:afrosine/core/common/app/providers/user_provider.dart';
import 'package:afrosine/src/home/presentation/widgets/recipe_list_item.dart';
import 'package:afrosine/src/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class FavoriteRecipesScreen extends StatefulWidget {
  static const routeName = '/favorite-recipes';

  @override
  _FavoriteRecipesScreenState createState() => _FavoriteRecipesScreenState();
}

class _FavoriteRecipesScreenState extends State<FavoriteRecipesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      if (userProvider.user != null) {
        context
            .read<RecipeBloc>()
            .add(GetFavoriteRecipesEvent(userId: userProvider.user!.uid));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Recipes'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.user == null) {
            return Center(
                child: Text('Please log in to view favorite recipes'));
          }

          return BlocBuilder<RecipeBloc, RecipeState>(
            builder: (context, state) {
              if (state is RecipeLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is RecipesLoaded) {
                final favoriteRecipes = state.recipes;
                if (favoriteRecipes.isEmpty) {
                  return Center(child: Text('No favorite recipes yet'));
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<RecipeBloc>().add(GetFavoriteRecipesEvent(
                        userId: userProvider.user!.uid));
                  },
                  child: ListView.builder(
                    itemCount: favoriteRecipes.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(favoriteRecipes[index].id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          context.read<RecipeBloc>().add(
                                ToggleFavoriteRecipeEvent(
                                  recipeId: favoriteRecipes[index].id,
                                  userProvider: userProvider,
                                ),
                              );
                        },
                        child: RecipeListItem(recipe: favoriteRecipes[index]),
                      );
                    },
                  ),
                );
              } else if (state is RecipeError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message),
                      ElevatedButton(
                        onPressed: () {
                          context.read<RecipeBloc>().add(
                              GetFavoriteRecipesEvent(
                                  userId: userProvider.user!.uid));
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
