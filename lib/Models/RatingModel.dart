import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  final int ratingScore;
  //final int ratingID;
  final String reviewComment;
  final String ratingDate;
  final String serviceType;
  final String foremanId; 

  Rating({
    required this.ratingScore,
    //required this.ratingID,
    required this.reviewComment,
    required this.ratingDate,
    required this.serviceType,
    required this.foremanId,
  });

  factory Rating.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Rating(
      ratingScore: data['ratingScore'] ?? 0,
      //ratingID: data['ratingID'] ?? 0,
      reviewComment: data['reviewComment'] ?? '',
      ratingDate: data['ratingDate'] ?? '', 
      serviceType: data['serviceType'] ?? '', 
      foremanId:
          data['foremanId'] ?? '', 
    );
  }

  factory Rating.fromMap(Map<String, dynamic> map, String docId) {
    return Rating(
      ratingScore: map['ratingScore'] ?? 0,
      //ratingID: map['ratingID'] ?? 0,
      reviewComment: map['reviewComment'] ?? '',
      ratingDate: map['ratingDate'] ?? '', 
      serviceType: map['serviceType'] ?? '', 
      foremanId:
          map['foremanId'] ?? '', 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ratingScore': ratingScore,
      //'ratingID': ratingID,
      'reviewComment': reviewComment,
      'ratingDate': ratingDate,
      'serviceType': serviceType,
      'foremanId': foremanId, 
    };
  }
}
