import 'package:afrosine/src/recipe/domain/entities/recipe.dart';
import 'package:afrosine/src/recipe/presentation/views/recipe_overview_screen.dart';
import 'package:flutter/material.dart';

class RecipeListItem extends StatelessWidget {
  final Recipe recipe;

  const RecipeListItem({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        recipe.imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Text(recipe.name),
      subtitle: Text(recipe.cuisine),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        Navigator.pushNamed(
          context,
          RecipeOverviewScreen.routeName,
          arguments: recipe,
        );
      },
    );
  }
}
