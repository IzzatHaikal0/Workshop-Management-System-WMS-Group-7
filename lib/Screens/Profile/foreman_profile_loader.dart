import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'view_profile_page_foreman.dart'; // Make sure this file exists

class ForemanProfileLoader extends StatelessWidget {
  const ForemanProfileLoader({super.key});

  Future<Map<String, dynamic>?> fetchForemanData(String foremanId) async {
    final doc =
        await FirebaseFirestore.instance
            .collection('foremen')
            .doc(foremanId)
            .get();
    return doc.exists ? doc.data() : null;
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Scaffold(body: Center(child: Text("User not logged in.")));
    }

    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchForemanData(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text("Failed to load profile.")),
          );
        } else {
          return ViewProfilePageForeman(foremanId: userId);
        }
      },
    );
  }
}
