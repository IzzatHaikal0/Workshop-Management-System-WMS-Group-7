//import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workshop_management_system/Models/RatingModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workshop_management_system/Models/foreman_model.dart';

class Ratingcontroller {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  // RETRIEVE ALL FOREMEN YANG PERNAH KERJA DENGAN WORKSHOP OWNER BASED ON ACCEPTED SCHEDULES
  //SAME FOREMEN CAN BE REPEATED IF THEY PICK/ACCEPT MULTIPLE SCHEDULES
  Future<List<Map<String, dynamic>>> getForemenByWorkshopOwner() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    final workshopOwnerId = currentUser.uid;

    // Step 1: Get accepted & unrated schedules
    QuerySnapshot scheduleSnapshot =
        await _firestore
            .collection('WorkshopSchedule')
            .where('workshopOwnerId', isEqualTo: workshopOwnerId)
            .where('status', isEqualTo: 'accepted')
            .where('isRated', isEqualTo: false)
            .get();

    if (scheduleSnapshot.docs.isEmpty) return [];

    // Collect foremanIds from these schedules
    final foremanIds =
        scheduleSnapshot.docs
            .map(
              (doc) =>
                  (doc.data() as Map<String, dynamic>)['foremanId'] as String,
            )
            .toSet()
            .toList();

    // Step 2: Get foreman details
    QuerySnapshot foremenSnapshot =
        await _firestore
            .collection('foremen')
            .where(FieldPath.documentId, whereIn: foremanIds)
            .get();

    // Map foremanId to foreman data
    final Map<String, Map<String, dynamic>> foremanDataMap = {
      for (var doc in foremenSnapshot.docs)
        doc.id: doc.data() as Map<String, dynamic>,
    };

    // Step 3: Build a list where each schedule includes foreman info
    final List<Map<String, dynamic>> result = [];

    for (var scheduleDoc in scheduleSnapshot.docs) {
      final scheduleData = scheduleDoc.data() as Map<String, dynamic>;
      final foremanId = scheduleData['foremanId'] as String;
      final foremanData = foremanDataMap[foremanId];

      if (foremanData == null) continue; // just in case

      final firstName = foremanData['firstName'] ?? '';
      final lastName = foremanData['lastName'] ?? '';
      final foremanName =
          ('$firstName $lastName').trim().isNotEmpty
              ? ('$firstName $lastName').trim()
              : 'Unknown';

      result.add({
        'scheduleId': scheduleDoc.id,
        'scheduleData': scheduleData,
        'foremanId': foremanId,
        'foremanName': foremanName,
        'foremanEmail': foremanData['email'] ?? '',
        'foremanPhoneNumber': foremanData['phoneNumber'] ?? '',
        'foremanData': foremanData,
        'jobDescription': scheduleData['jobDescription'] ?? 'No Description',
      });
    }

    return result;
  }

  //FUNCTION TO GET FOREMAN INFORMATION YANG ADA ACCEPTED SCHEDULE (GUNA DALAM ADDRATING PAGE)
  Future<Map<String, dynamic>?> getForemanWithSchedule(String foremanId) async {
    try {
      // Fetch foreman info
      DocumentSnapshot foremanDoc =
          await _firestore.collection('foremen').doc(foremanId).get();
      if (!foremanDoc.exists) return null;

      Map<String, dynamic> foremanData =
          foremanDoc.data() as Map<String, dynamic>;

      // Fetch schedules related to this foreman (assuming one schedule or list)
      QuerySnapshot scheduleSnapshot =
          await _firestore
              .collection('WorkshopSchedule')
              .where('foremanId', isEqualTo: foremanId)
              .get();

      List<Map<String, dynamic>> schedules =
          scheduleSnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();

      // Add schedules to foremanData map
      foremanData['schedules'] = schedules;

      return foremanData;
    } catch (e) {
      debugPrint('Error fetching foreman with schedule: $e');
      return null;
    }
  }
  
  //WORKSHOP OWNER ADD RATING INTO DATABASE
  Future<void> addRating(Rating rating, String scheduleDocId) async {
    try {
      final ratingData =
          rating.toJson()
            ..['workshopOwnerId'] = FirebaseAuth.instance.currentUser!.uid;
      ratingData['ratingDate'] =
          DateTime.now().toIso8601String(); // Add current date

      final docRef = await _firestore.collection('Rating').add(ratingData);
      await docRef.update({'status': 'rated'});

       await _firestore
          .collection('WorkshopSchedule')
          .doc(scheduleDocId)
          .update({'isRated': true}); 
    } catch (e) {
      debugPrint('Error adding rating: $e');
    }
  }

  //GET AND DISPLAY RATED FOREMAN IN RATING HISTORY PAGE
  Future<List<Map<String, dynamic>>> getRatedForeman() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return [];

  final workshopOwnerId = currentUser.uid;

  try {
    // Step 1: Get rated ratings
    final ratingSnapshot = await _firestore
        .collection('Rating')
        .where('workshopOwnerId', isEqualTo: workshopOwnerId)
        .where('status', isEqualTo: 'rated')
        .get();

    if (ratingSnapshot.docs.isEmpty) return [];

    final ratedForemanEntries = ratingSnapshot.docs.map((doc) {
      return {
        'docId': doc.id,  // 🔧 Add this line
        'foremanId': doc['foremanId'] as String,
        'ratingScore': doc['ratingScore'] as int,
        'reviewComment': doc['reviewComment'] as String,
        'serviceType': doc['serviceType'] as String,
        'ratingDate': doc['ratingDate'],
      };
    }).toList();

    // Step 2: Get detailed info from foremen collection
    List<Map<String, dynamic>> ratedForemen = [];

    for (var entry in ratedForemanEntries) {
      final foremanDoc = await _firestore
          .collection('foremen')
          .doc(entry['foremanId'] as String)
          .get();

      if (foremanDoc.exists) {
        final foremanData = foremanDoc.data()!;
        foremanData['foremanId'] = entry['foremanId'];
        foremanData['ratingScore'] = entry['ratingScore'];
        foremanData['docId'] = entry['docId']; // 🔧 Pass to EditRatingPage
        foremanData['reviewComment'] = entry['reviewComment'];
        foremanData['serviceType'] = entry['serviceType'];
        foremanData['ratingDate'] = entry['ratingDate'];
        ratedForemen.add(foremanData);
      }
    }

    return ratedForemen;
  } catch (e) {
    debugPrint('Error getting rated foremen: $e');
    return [];
  }
}

  //RETRIEVE RATING BY ID
  Future<Rating?> getRatingById(String docId) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('Rating')
        .doc(docId)
        .get();

    if (docSnapshot.exists) {
      return Rating.fromMap(docSnapshot.data()!, docSnapshot.id);
    }
    return null;
  }

  //EDIT RATING YANG WORKSHOP OWNER BUAT
  Future<void> editRating(Rating rating) async {
    if (rating.docId != null) {
      await FirebaseFirestore.instance
          .collection('Rating')
          .doc(rating.docId)
          .update(rating.toJson());
    } else {
      debugPrint('Rating document ID is null, cannot edit.');
    }
  }

  //DELETE RATING YANG WORKSHOP OWNER BUAT
  Future<void> deleteRating(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('Rating').doc(docId).delete();
      debugPrint('Rating deleted successfully');
    } catch (e) {
      debugPrint('Failed to delete rating: $e');
      rethrow;
    }
  }

  //GET RATING BY WORKSHOP OWNER (TO ONE FOREMAN)
  //CHECK THE RATING BASED ON FOREMAN ID
  Future<ForemanModel?> getForemanProfile(String foremanId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('foremen')
          .doc(foremanId)
          .get();

      if (doc.exists && doc.data() != null) {
        return ForemanModel.fromMap(doc.data()!);
      }
    } catch (e) {
      print('Error fetching foreman profile: $e');
    }
    return null;
  }



  Future<List<Rating>> getRatingsForForeman(String foremanId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Rating')
        .where('foremanId', isEqualTo: foremanId)
        .where('status', isEqualTo: 'rated')
        .get();
    return snapshot.docs.map((doc) => Rating.fromMap(doc.data(), doc.id)).toList();
  }

  //METHOD NAK KIRA AVERAAGE RATING DAN HIGHEST RATING
  Future<Map<String, dynamic>> loadRatingsForForeman(String foremanId) async {
  final ratings = await getRatingsForForeman(foremanId);
  if (ratings.isEmpty) {
    return {
      'ratings': [],
      'average': 0.0,
      'highest': 0.0,
    };
  }

  final scores = ratings.map((r) => r.ratingScore.toDouble()).toList();
  final averageRating = scores.reduce((a, b) => a + b) / scores.length;
  final highestRating = scores.reduce((a, b) => a > b ? a : b);

  return {
    'ratings': ratings,
    'average': averageRating,
    'highest': highestRating,
  };
}


}
