import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class SaveRegistrationData {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> saveUser(UserModel user) async {
    try {
      // 1. Register user with Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: user.email,
            password: user.password,
          );

      String uid = userCredential.user!.uid;
      await _firestore.collection('foremen').doc(uid).set({
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': user.email,
        'phoneNumber': user.phoneNumber,
        'role': user.userRole.toLowerCase().replaceAll(' ', '_'),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2. Save basic user data to 'users' collection
      await _firestore.collection('workshop_owner').doc(uid).set({
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': user.email,
        'phoneNumber': user.phoneNumber,
        'role': user.userRole.toLowerCase().replaceAll(' ', '_'),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3. Save profile to role-specific collection
      if (user.userRole.toLowerCase() == 'foreman') {
        await _firestore.collection('foremen').doc(uid).set({
          'first_name': user.firstName,
          'last_name': user.lastName,
          'email': user.email,
          'phone_number': user.phoneNumber,
          'foremanAddress': '',
          'foremanProfilePicture': '',
          'foremanSkills': '',
          'foremanWorkExperience': '',
        });
      } else if (user.userRole.toLowerCase() == 'workshop_owner') {
        await _firestore.collection('workshop_owners').doc(uid).set({
          'first_name': user.firstName,
          'last_name': user.lastName,
          'email': user.email,
          'phone_number': user.phoneNumber,
          'workshopName': '',
          'workshopAddress': '',
          'workshopPhone': '',
          'workshopEmail': '',
          'workshopProfilePicture': '',
          'workshopOperationHour': '',
          'workshopDetail': '',
        });
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving user data: $e');
      }
      return false;
    }
  }
}
