import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workshop_management_system/Models/RatingModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Ratingcontroller {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  //FUNCTION UNTUL LISTKAN SEMUA FOREMEN YANG ADA SCHEDULE CREATED BY LOGIN WORKSHOP OWNER
  Future<List<Map<String, dynamic>>> getForemenByWorkshopOwner() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    final workshopOwnerId = currentUser.uid;

    // Get accepted schedules for this workshop owner
    QuerySnapshot scheduleSnapshot = await _firestore
        .collection('WorkshopSchedule')
        .where('workshopOwnerId', isEqualTo: workshopOwnerId)
        .where('status', isEqualTo: 'accepted')
        .get();

    final foremanIds = scheduleSnapshot.docs
        .map((doc) => doc['foremanId'] as String)
        .toSet()
        .toList();

    if (foremanIds.isEmpty) return [];

    // Get ratings made by this workshop owner
    QuerySnapshot ratingSnapshot = await _firestore
        .collection('Rating')
        .where('workshopOwnerId', isEqualTo: workshopOwnerId)
        .where('status', isEqualTo: 'rated')
        .get();

    // Extract rated foreman IDs
    final ratedForemanIds = ratingSnapshot.docs
        .map((doc) => doc['foremanId'] as String)
        .toSet();

    // Filter out foremen that are already rated
    final unratedForemanIds = foremanIds.where((id) => !ratedForemanIds.contains(id)).toList();

    if (unratedForemanIds.isEmpty) return [];

    // Get foreman details for only unrated ones
    QuerySnapshot foremenSnapshot = await _firestore
        .collection('foremen')
        .where(FieldPath.documentId, whereIn: unratedForemanIds)
        .get();

    final result = <Map<String, dynamic>>[];
    for (var doc in foremenSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final firstName = data['first_name'] as String? ?? '';
      final lastName = data['last_name'] as String? ?? '';
      final phoneNumber = data['phone_number'] as String? ?? '';
      final foremanId = doc.id;

      final foremanName = ('$firstName $lastName').trim().isNotEmpty
          ? ('$firstName $lastName').trim()
          : 'Unknown';

      result.add({
        'foremanId': foremanId,
        'foremanName': foremanName,
        'foremanEmail': data['email'] ?? '',
        'foremanPhoneNumber': phoneNumber,
        'foremanData': data,
      });
    }

    return result;
  }


    //FUNCTION TO GET FOREMAN INFORMATION YANG ADA ACCEPTED SCHEDULE (GUNA DALAM ADDRATING PAGE)
    Future<Map<String, dynamic>?> getForemanWithSchedule(String foremanId) async {
      try {
        // Fetch foreman info
        DocumentSnapshot foremanDoc = await _firestore.collection('foremen').doc(foremanId).get();
        if (!foremanDoc.exists) return null;

        Map<String, dynamic> foremanData = foremanDoc.data() as Map<String, dynamic>;

        // Fetch schedules related to this foreman (assuming one schedule or list)
        QuerySnapshot scheduleSnapshot = await _firestore
            .collection('WorkshopSchedule')
            .where('foremanId', isEqualTo: foremanId)
            .get();

        // You can decide how to handle multiple schedules.
        // For example, take the first one or combine all:
        List<Map<String, dynamic>> schedules = scheduleSnapshot.docs
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

  Future<void> addRating(Rating rating) async {
    try {
      final ratingData = rating.toJson()..['workshopOwnerId'] = FirebaseAuth.instance.currentUser!.uid;
      ratingData['ratingDate'] = DateTime.now().toIso8601String(); // Add current date

      final docRef = await _firestore.collection('Rating').add(ratingData);
      await docRef.update({'status': 'rated'});
    } catch (e) {
      debugPrint('Error adding rating: $e');
    }
  }


}