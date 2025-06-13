import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'workshop_view_page.dart'; // Make sure this file exists

class WorkshopOwnerProfileLoader extends StatelessWidget {
  const WorkshopOwnerProfileLoader({super.key});

  Future<Map<String, dynamic>?> fetchWorkshopOwnerData(String ownerId) async {
    final doc =
        await FirebaseFirestore.instance
            .collection('workshop_owner')
            .doc(ownerId)
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
      future: fetchWorkshopOwnerData(userId),
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
          return ViewProfilePageWorkshopOwner(workshopOwnerId: userId);
        }
      },
    );
  }
}
