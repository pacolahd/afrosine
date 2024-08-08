import 'package:equatable/equatable.dart';

class Feedback extends Equatable {
  const Feedback({
    required this.id,
    required this.userId,
    required this.recipeId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String recipeId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, userId, recipeId, rating, comment, createdAt];
}
