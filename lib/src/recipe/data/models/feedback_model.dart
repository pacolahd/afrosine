import 'package:afrosine/core/utils/typedefs.dart';
import 'package:afrosine/src/recipe/domain/entities/feedback.dart';

class FeedbackModel extends Feedback {
  const FeedbackModel({
    required super.id,
    required super.userId,
    required super.recipeId,
    required super.rating,
    required super.comment,
    required super.createdAt,
  });

  factory FeedbackModel.fromMap(DataMap map) {
    return FeedbackModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      recipeId: map['recipeId'] as String,
      rating: (map['rating'] as num).toDouble(),
      comment: map['comment'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'recipeId': recipeId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
