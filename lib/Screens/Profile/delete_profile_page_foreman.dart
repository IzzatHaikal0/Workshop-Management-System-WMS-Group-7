import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteProfilePageForeman extends StatelessWidget {
  final String foremanId;

  const DeleteProfilePageForeman({super.key, required this.foremanId});

  Future<void> _deleteProfile(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('foremen')
          .doc(foremanId)
          .delete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile deleted successfully')),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete profile: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Foreman Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Are you sure you want to delete this profile? This action cannot be undone.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => _deleteProfile(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
