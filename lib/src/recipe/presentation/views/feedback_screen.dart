import 'package:afrosine/core/common/app/providers/user_provider.dart';
import 'package:afrosine/src/recipe/data/models/feedback_model.dart';
import 'package:afrosine/src/recipe/domain/entities/recipe.dart';
import 'package:afrosine/src/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackScreen extends StatefulWidget {
  final Recipe recipe;
  static const routeName = '/feedback';

  const FeedbackScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _commentController = TextEditingController();
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Leave Feedback')),
      body: BlocConsumer<RecipeBloc, RecipeState>(
        listener: (context, state) {
          if (state is FeedbackAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Feedback submitted successfully')),
            );
            Navigator.of(context).pop();
          } else if (state is RecipeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rate this recipe:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 40,
                      ),
                      onPressed: () {
                        setState(() {
                          _rating = index + 1;
                        });
                      },
                    );
                  }),
                ),
                SizedBox(height: 24),
                Text(
                  'Your comment:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Share your thoughts about this recipe',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: state is RecipeLoading
                      ? null
                      : () {
                          if (_rating > 0 &&
                              _commentController.text.isNotEmpty) {
                            context.read<RecipeBloc>().add(
                                  AddFeedbackEvent(
                                    FeedbackModel(
                                      id: '', // This will be generated on the server
                                      userId: context
                                          .read<UserProvider>()
                                          .user!
                                          .uid,
                                      recipeId: widget.recipe.id,
                                      rating: _rating,
                                      comment: _commentController.text.trim(),
                                      createdAt: DateTime.now(),
                                    ),
                                  ),
                                );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Please provide both rating and comment')),
                            );
                          }
                        },
                  child: state is RecipeLoading
                      ? CircularProgressIndicator()
                      : Text('Submit Feedback'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
