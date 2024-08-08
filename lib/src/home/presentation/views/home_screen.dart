import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:afrosine/core/resources/media_resources.dart';
import 'package:afrosine/core/resources/theme/app_colors.dart';
import 'package:afrosine/src/home/presentation/views/recipe_filter_screen.dart';
import 'package:afrosine/src/home/presentation/views/recipe_search_screen.dart';
import 'package:afrosine/src/home/presentation/widgets/recipe_card.dart';
import 'package:afrosine/src/recipe/domain/usecases/get_recipes.dart';
import 'package:afrosine/src/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedMealType = 'Lunch';
  @override
  void initState() {
    super.initState();
    context.read<RecipeBloc>().add(const GetRecipesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildMealTypeButtons(),
            Expanded(child: _buildRecipeGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage(MediaRes.defaultUser),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // context.watch<UserProvider>().user!.userName,
                context.userProvider.user!.userName,
                style: context.theme.textStyles.h3Bold,
              ),
              Text(
                'Explore the Taste of Africa',
                style: context.theme.textStyles.body,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RecipeSearchScreen.routeName);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Search...', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: AppColors.milkyWhite,
                showDragHandle: true,
                elevation: 0,
                useSafeArea: true,
                builder: (context) => FilterScreen(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ['Breakfast', 'Lunch', 'Dinner'].map((type) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedMealType == type
                  ? AppColors.dark
                  : context.theme.colors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: () {
              setState(() {
                selectedMealType = type;
              });
              context
                  .read<RecipeBloc>()
                  .add(FilterRecipesEvent(FilterParams(mealTypes: [type])));
            },
            child: Text(type,
                style: context.theme.textStyles.caption.copyWith(
                  color: AppColors.white,
                )),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecipeGrid() {
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        if (state is RecipesLoaded) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.recipes.length,
            itemBuilder: (context, index) {
              return RecipeCard(recipe: state.recipes[index]);
            },
          );
        } else if (state is RecipeError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
