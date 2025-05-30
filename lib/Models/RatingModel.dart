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

  factory Rating.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Rating(
      ratingScore: data['ratingScore'] ?? 0,
      ratingID: data['ratingID'] ?? 0,
      reviewComment: data['reviewComment'] ?? '',
    );
  } 

  factory Rating.fromMap(Map<String, dynamic> map, String docId) {
    return Rating(
      ratingScore: map['ratingScore'] ?? 0,
      ratingID: map['ratingID'] ?? 0,
      reviewComment: map['reviewComment'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ratingScore': ratingScore,
      'ratingID': ratingID,
      'reviewComment': reviewComment,
    };
  }
}
