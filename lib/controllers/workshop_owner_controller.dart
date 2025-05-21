import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/workshop_owner_model.dart';

class WorkshopOwnerController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔽 Get current user UID
  String get userId => _auth.currentUser!.uid;

  // 🔹 Add new workshop owner profile
  Future<void> addWorkshopOwnerProfile(WorkshopOwnerModel owner) async {
    try {
      await _firestore
          .collection('workshop_owners')
          .doc(userId)
          .set(owner.toMap());
    } catch (e) {
      throw Exception('Failed to add workshop owner profile: $e');
    }
  }

  // 🔹 Fetch workshop owner profile
  Future<WorkshopOwnerModel?> getWorkshopOwnerProfile() async {
    try {
      final doc =
          await _firestore.collection('workshop_owners').doc(userId).get();
      if (doc.exists) {
        return WorkshopOwnerModel.fromMap(doc.data()!);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  // 🔹 Update workshop owner profile
  Future<void> updateWorkshopOwnerProfile(
      WorkshopOwnerModel updatedOwner) async {
    try {
      await _firestore
          .collection('workshop_owners')
          .doc(userId)
          .update(updatedOwner.toMap());
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // 🔹 Delete workshop owner profile
  Future<void> deleteWorkshopOwnerProfile() async {
    try {
      await _firestore.collection('workshop_owners').doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete profile: $e');
    }
  }
}
