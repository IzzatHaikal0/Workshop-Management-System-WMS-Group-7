import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'view_profile_page_foreman.dart';
import '../../services/profile_service.dart';

class ForemanProfileLoader extends StatefulWidget {
  const ForemanProfileLoader({super.key});

  @override
  State<ForemanProfileLoader> createState() => _ForemanProfileLoaderState();
}

class _ForemanProfileLoaderState extends State<ForemanProfileLoader> {
  bool isLoading = true;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final data = await ProfileService().fetchForemanProfile(uid);
      if (mounted) {
        setState(() {
          userData = data;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (userData == null) {
      return const Scaffold(
        body: Center(child: Text('No profile data found.')),
      );
    }

    return ViewProfilePageForeman(
      foremanId: FirebaseAuth.instance.currentUser!.uid,
    );
  }
}
