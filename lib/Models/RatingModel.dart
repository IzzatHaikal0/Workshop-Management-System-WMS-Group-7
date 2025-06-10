import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  final int ratingScore;
  final int ratingID;
  final String reviewComment;

  Rating({
    required this.ratingScore,
    required this.ratingID,
    required this.reviewComment,
  });
}
