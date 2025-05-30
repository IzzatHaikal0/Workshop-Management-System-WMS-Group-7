import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class SaveRegistrationData {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> saveUser(UserModel user) async {
    try {
      // Register user with Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: user.email,
            password: user.password,
          );

      String uid = userCredential.user!.uid;

      // Normalize role string
      String role = user.userRole.trim().toLowerCase().replaceAll(' ', '_');

      if (kDebugMode) {
        print('Saving user with normalized role: $role');
      }

      // Save profile data to correct collection based on role
      if (role == 'foreman') {
        await _firestore.collection('foremen').doc(uid).set({
          'first_name': user.firstName,
          'last_name': user.lastName,
          'email': user.email,
          'phone_number': user.phoneNumber,
          'foremanAddress': '',
          'foremanProfilePicture': '',
          'foremanSkills': '',
          'foremanWorkExperience': '',
          'role': 'foreman',
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else if (role == 'workshop_owner') {
        await _firestore.collection('workshop_owner').doc(uid).set({
          'firstName': user.firstName,
          'lastName': user.lastName,
          'email': user.email,
          'phoneNumber': user.phoneNumber,
          'workshopName': '',
          'workshopAddress': '',
          'workshopPhone': '',
          'workshopEmail': '',
          'workshopProfilePicture': '',
          'workshopOperationHour': '',
          'workshopDetail': '',
          'role': 'workshop owner',
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        if (kDebugMode) {
          print('❌ Unknown role: $role');
        }
        return false;
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('🔥 Error saving user data: $e');
      }
      return false;
    }
  }
}
