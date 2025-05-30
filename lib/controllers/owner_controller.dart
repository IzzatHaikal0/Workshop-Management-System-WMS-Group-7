import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/owner_model.dart';

class WorkshopOwnerController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<OwnerModel?> getOwnerProfile() async {
    try {
      var doc = await _firestore.collection('workshopOwners').doc(uid).get();
      if (doc.exists) {
        return OwnerModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching owner profile: $e');
      }
      return null;
    }
  }

  Future<void> updateOwnerProfile(OwnerModel owner) async {
    try {
      await _firestore.collection('workshopOwners').doc(uid).set(owner.toMap());
    } catch (e) {
      if (kDebugMode) {
        print('Error updating owner profile: $e');
      }
      rethrow;
    }
  }
}
