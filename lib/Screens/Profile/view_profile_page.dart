// lib/Screens/profile/view_profile.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../main.dart'; // For navigation routes

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key});

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? profileData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    if (user == null) {
      setState(() {
        isLoading = false;
        profileData = null;
      });
      return;
    }

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('profiles')
              .doc(user!.uid)
              .get();

      if (doc.exists) {
        profileData = doc.data();
      } else {
        profileData = null;
      }
    } catch (e) {
      profileData = null;
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (user == null) {
      return const Center(child: Text('No user logged in.'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Your Profile')),
      body:
          profileData == null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No profile found. Please add your profile.'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.profileAdd,
                        ).then((_) => fetchProfile());
                      },
                      child: const Text('Add Profile'),
                    ),
                  ],
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text('Name'),
                      subtitle: Text(profileData!['name'] ?? 'N/A'),
                    ),
                    ListTile(
                      title: const Text('Email'),
                      subtitle: Text(user!.email ?? 'N/A'),
                    ),
                    ListTile(
                      title: const Text('Phone'),
                      subtitle: Text(profileData!['phone'] ?? 'N/A'),
                    ),
                    ListTile(
                      title: const Text('Address'),
                      subtitle: Text(profileData!['address'] ?? 'N/A'),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.profileEdit,
                          arguments: profileData,
                        ).then((_) => fetchProfile());
                      },
                      child: const Text('Edit Profile'),
                    ),
                  ],
                ),
              ),
    );
  }
}
