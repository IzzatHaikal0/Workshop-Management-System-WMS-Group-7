import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workshop_management_system/Models/ScheduleModel.dart';

class ScheduleController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to fetch schedules from Firestore
  Stream<List<Schedule>> getSchedules() {
    return _firestore.collection('WorkshopSchedule').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return Schedule.fromFirestore(doc);
        }).toList();
      },
    );
  }

// Add new schedule to Firestore
  Future<void> addSchedule(Schedule schedule) async {
    try {
      await _firestore.collection('WorkshopSchedule').add(schedule.toJson());
      debugPrint('Schedule added successfully');
    } catch (e) {
      debugPrint('Failed to add schedule: $e');
      rethrow;
    }
  }
}

