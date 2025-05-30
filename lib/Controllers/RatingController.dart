import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workshop_management_system/Models/RatingModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Ratingcontroller {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<List<Map<String, dynamic>>> getForemenByWorkshopOwner(String workshopOwnerId) async {
      // Step 1: Get schedules accepted by foremen for this owner
      QuerySnapshot scheduleSnapshot = await _firestore
        .collection('WorkshopSchedule')
        .where('workshopOwnerId', isEqualTo: workshopOwnerId)
        .where('status', whereIn: ['accepted']) // adjust statuses as needed
        .get();

      // Extract unique foreman IDs
      final foremanIds = scheduleSnapshot.docs
          .map((doc) => doc['foremanId'] as String)
          .toSet()
          .toList();

      if (foremanIds.isEmpty) return [];

      // Step 2: Query foremen collection for those foreman IDs
      QuerySnapshot foremenSnapshot = await _firestore
          .collection('foremen')
          .where(FieldPath.documentId, whereIn: foremanIds)
          .get();

      // Map to list of foreman data
      return foremenSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
  }

}