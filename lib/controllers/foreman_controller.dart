import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/foreman_model.dart';

class ForemanController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch Foreman profile by user ID
  Future<ForemanModel?> fetchForemanProfile(
      String userId, UserModel user) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('foreman_profile')
          .doc('profile_doc')
          .get();

      if (doc.exists) {
        return ForemanModel.fromUserAndMap(userId, user, doc.data()!);
      } else {
        return null; // No profile found
      }
    } catch (e) {
      print('Error fetching foreman profile: $e');
      return null;
    }
  }

  // Save or update Foreman profile
  Future<bool> saveForemanProfile(String userId, ForemanModel profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('foreman_profile')
          .doc('profile_doc')
          .set(profile.toMap(), SetOptions(merge: true));
      return true;
    } catch (e) {
      print('Error saving foreman profile: $e');
      return false;
    }
  }

  // Delete Foreman profile
  Future<bool> deleteForemanProfile(String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('foreman_profile')
          .doc('profile_doc')
          .delete();
      return true;
    } catch (e) {
      print('Error deleting foreman profile: $e');
      return false;
    }
  }
}
