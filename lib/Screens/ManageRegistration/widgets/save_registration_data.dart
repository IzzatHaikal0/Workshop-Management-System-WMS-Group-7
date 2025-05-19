import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> saveRegistrationData(
  String role,
  String firstName,
  String lastName,
  String email,
  String phone,
  String password,
) async {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  UserCredential userCred = await auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );

  await firestore.collection('users').doc(userCred.user!.uid).set({
    'user_role': role,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone_number': phone,
    'uid': userCred.user!.uid,
  });
}
