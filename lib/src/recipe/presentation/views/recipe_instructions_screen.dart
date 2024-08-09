import 'package:afrosine/src/recipe/domain/entities/recipe.dart';
import 'package:afrosine/src/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:afrosine/src/recipe/presentation/views/feedback_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecipeInstructionsScreen extends StatefulWidget {
  static const routeName = '/recipe-instructions';
  final Recipe recipe;

  const RecipeInstructionsScreen({Key? key, required this.recipe})
      : super(key: key);

  @override
  _RecipeInstructionsScreenState createState() =>
      _RecipeInstructionsScreenState();
}

class _RecipeInstructionsScreenState extends State<RecipeInstructionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RecipeBloc>().add(GetRecipeFeedbackEvent(widget.recipe.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.recipe.name,
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.recipe.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ingredients',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 16),
                  ...widget.recipe.ingredients.map((ingredient) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.fiber_manual_record, size: 8),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${ingredient.quantity} ${ingredient.unit} ${ingredient.name}',
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(height: 24),
                  Text(
                    'Instructions',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 16),
                  ...widget.recipe.instructions
                      .asMap()
                      .entries
                      .map((entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  child: Text('${entry.key + 1}'),
                                  radius: 12,
                                ),
                                SizedBox(width: 16),
                                Expanded(child: Text(entry.value)),
                              ],
                            ),
                          )),
                  SizedBox(height: 24),
                  Text(
                    'Feedback',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 16),
                  BlocBuilder<RecipeBloc, RecipeState>(
                    builder: (context, state) {
                      if (state is RecipeFeedbackLoaded) {
                        return Column(
                          children: state.feedback
                              .map((feedback) => Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              ...List.generate(
                                                  5,
                                                  (index) => Icon(
                                                        index < feedback.rating
                                                            ? Icons.star
                                                            : Icons.star_border,
                                                        color: Colors.amber,
                                                        size: 20,
                                                      )),
                                              SizedBox(width: 8),
                                              Text(feedback.createdAt
                                                  .toString()
                                                  .substring(0, 10)),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(feedback.comment),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        );
                      } else if (state is RecipeLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is RecipeError) {
                        return Text('Error loading feedback: ${state.message}');
                      }
                      return Text('No feedback available');
                    },
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        FeedbackScreen.routeName,
                        arguments: widget.recipe,
                      );
                    },
                    child: Text('Leave Feedback'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
