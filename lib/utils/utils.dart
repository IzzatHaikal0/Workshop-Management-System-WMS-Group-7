import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> getUserRole() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return null;

  final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

  if (userDoc.exists) {
    return userDoc.data()?['userType']; // 'owner' or 'foreman'
  }

  return null;
}
