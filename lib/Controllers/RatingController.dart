//import 'dart:math';

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

    // Step 1: Get accepted schedules for this workshop owner
    QuerySnapshot scheduleSnapshot =
        await _firestore
            .collection('WorkshopSchedule')
            .where('workshopOwnerId', isEqualTo: workshopOwnerId)
            .where('status', isEqualTo: 'accepted')
            .get();

    // Map: foremanId -> list of schedules
    final Map<String, List<Map<String, dynamic>>> foremanSchedules = {};

    for (var doc in scheduleSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final foremanId = data['foremanId'] as String;

      if (!foremanSchedules.containsKey(foremanId)) {
        foremanSchedules[foremanId] = [];
      }
      foremanSchedules[foremanId]!.add({'scheduleId': doc.id, ...data});
    }

    final foremanIds = foremanSchedules.keys.toList();

    if (foremanIds.isEmpty) return [];

    // Step 2: Get rated foremen
    QuerySnapshot ratingSnapshot =
        await _firestore
            .collection('Rating')
            .where('workshopOwnerId', isEqualTo: workshopOwnerId)
            .where('status', isEqualTo: 'rated')
            .get();

    final ratedForemanIds =
        ratingSnapshot.docs.map((doc) => doc['foremanId'] as String).toSet();

    // Step 3: Filter unrated foremen
    final unratedForemanIds =
        foremanIds.where((id) => !ratedForemanIds.contains(id)).toList();

    if (unratedForemanIds.isEmpty) return [];

    // Step 4: Fetch foreman details
    QuerySnapshot foremenSnapshot =
        await _firestore
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

      final foremanName =
          ('$firstName $lastName').trim().isNotEmpty
              ? ('$firstName $lastName').trim()
              : 'Unknown';

      result.add({
        'foremanId': foremanId,
        'foremanName': foremanName,
        'foremanEmail': data['email'] ?? '',
        'foremanPhoneNumber': phoneNumber,
        'foremanData': data,
        'WorkshopSchedule': foremanSchedules[foremanId] ?? [],
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

  Future<void> addRating(Rating rating) async {
    try {
      final ratingData =
          rating.toJson()
            ..['workshopOwnerId'] = FirebaseAuth.instance.currentUser!.uid;
      ratingData['ratingDate'] =
          DateTime.now().toIso8601String(); // Add current date

      final docRef = await _firestore.collection('Rating').add(ratingData);
      await docRef.update({'status': 'rated'});
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
      final ratingSnapshot =
          await _firestore
              .collection('Rating')
              .where('workshopOwnerId', isEqualTo: workshopOwnerId)
              .where('status', isEqualTo: 'rated')
              .get();

      if (ratingSnapshot.docs.isEmpty) return [];

      final ratedForemanIds =
          ratingSnapshot.docs
              .map(
                (doc) => {
                  'foremanId': doc['foremanId'] as String,
                  'ratingScore': doc['ratingScore'] as int,
                },
              )
              .toList();

      // Step 2: Get detailed info from foremen collection
      List<Map<String, dynamic>> ratedForemen = [];

      for (var entry in ratedForemanIds) {
        final foremanDoc =
            await _firestore
                .collection('foremen')
                .doc(entry['foremanId'] as String)
                .get();

        if (foremanDoc.exists) {
          final foremanData = foremanDoc.data()!;
          foremanData['foremanId'] = entry['foremanId'];
          foremanData['ratingScore'] = entry['ratingScore'];
          ratedForemen.add(foremanData);
        }
      }

      return ratedForemen;
    } catch (e) {
      debugPrint('Error getting rated foremen: $e');
      return [];
    }
  }

  Future<Rating?> getRatingById(String foremanId) async {
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('Rating')
            .where('foremanId', isEqualTo: foremanId)
            .get();
    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      return Rating.fromMap(doc.data(), doc.id);
    }
    return null;
  }
}
