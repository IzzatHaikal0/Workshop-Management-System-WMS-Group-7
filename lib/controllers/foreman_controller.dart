import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/foreman_model.dart';

class ForemanController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<ForemanModel?> getForemanProfile() async {
    try {
      var doc = await _firestore.collection('foremen').doc(uid).get();
      if (doc.exists) {
        return ForemanModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error fetching foreman profile: $e');
      return null;
    }
  }

  Future<void> updateForemanProfile(ForemanModel foreman) async {
    try {
      await _firestore.collection('foremen').doc(uid).set(foreman.toMap());
    } catch (e) {
      print('Error updating foreman profile: $e');
      throw e;
    }
  }
}
