import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatelessWidget {
  final Map<String, dynamic>? existingProfile;
  final String? role;

  const EditProfilePage({super.key, this.existingProfile, this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Simulate Save & Go Back"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class AddProfilePage extends StatelessWidget {
  final String? role;

  const AddProfilePage({super.key, this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Profile")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Simulate Save & Go Back"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key});

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  Map<String, dynamic>? profileData;
  String? _role;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileAndRole();
  }

  Future<void> _loadProfileAndRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final roleDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      final role = roleDoc.data()?['role'];

      if (role == 'foreman' || role == 'workshop_owner') {
        final profileDoc =
            await FirebaseFirestore.instance
                .collection(role == 'foreman' ? 'foremen' : 'workshop_owner')
                .doc(user.uid)
                .get();

        setState(() {
          _role = role;
          profileData = profileDoc.data();
          isLoading = false;
        });
      } else {
        setState(() {
          _role = null;
          profileData = null;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _role = null;
        profileData = null;
        isLoading = false;
      });
    }
  }

  Future<void> _deleteProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _role == null) return;

    final collectionName = _role == 'foreman' ? 'foremen' : 'workshop_owner';

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text(
              'Are you sure you want to delete your profile?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      setState(() => isLoading = true);
      try {
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(user.uid)
            .delete();
        setState(() {
          profileData = null;
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile deleted successfully')),
        );
      } catch (e) {
        setState(() => isLoading = false);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting profile: $e')));
      }
    }
  }

  Widget _buildProfileCard(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(value),
    );
  }

  Widget _buildForemanProfile() {
    return _buildProfileCard("Foreman Details", [
      _buildInfoTile(
        "First Name",
        profileData?['first_name'] ?? '',
        Icons.person,
      ),
      _buildInfoTile(
        "Last Name",
        profileData?['last_name'] ?? '',
        Icons.person_outline,
      ),
      _buildInfoTile("Phone", profileData?['phone_number'] ?? '', Icons.phone),
      _buildInfoTile(
        "Address",
        profileData?['foremanAddress'] ?? '',
        Icons.home,
      ),
      _buildInfoTile(
        "Skills",
        profileData?['foremanSkills'] ?? '',
        Icons.build,
      ),
      _buildInfoTile(
        "Work Experience",
        profileData?['foremanWorkExperience'] ?? '',
        Icons.work_history,
      ),
    ]);
  }

  Widget _buildWorkshopOwnerProfile() {
    return _buildProfileCard("Workshop Owner Details", [
      _buildInfoTile(
        "First Name",
        profileData?['first_name'] ?? '',
        Icons.person,
      ),
      _buildInfoTile(
        "Last Name",
        profileData?['last_name'] ?? '',
        Icons.person_outline,
      ),
      _buildInfoTile("Phone", profileData?['phone_number'] ?? '', Icons.phone),
      _buildInfoTile(
        "Workshop Name",
        profileData?['workshopName'] ?? '',
        Icons.home_repair_service,
      ),
      _buildInfoTile(
        "Workshop Address",
        profileData?['workshopAddress'] ?? '',
        Icons.location_on,
      ),
      _buildInfoTile(
        "Workshop Phone",
        profileData?['workshopPhone'] ?? '',
        Icons.phone_android,
      ),
      _buildInfoTile(
        "Operation Hours",
        profileData?['workshopOperationHour'] ?? '',
        Icons.access_time,
      ),
      _buildInfoTile(
        "Details",
        profileData?['workshopDetail'] ?? '',
        Icons.info_outline,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          if (profileData == null)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add Profile',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddProfilePage(role: _role),
                  ),
                );
                _loadProfileAndRole();
              },
            ),
          if (profileData != null) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Profile',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => EditProfilePage(
                          existingProfile: profileData,
                          role: _role,
                        ),
                  ),
                );
                _loadProfileAndRole();
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete Profile',
              onPressed: _deleteProfile,
            ),
          ],
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            profileData == null || _role == null
                ? const Center(child: Text('No profile data available.'))
                : ListView(
                  children: [
                    if (_role == 'foreman') _buildForemanProfile(),
                    if (_role == 'workshop_owner') _buildWorkshopOwnerProfile(),
                  ],
                ),
      ),
    );
  }
}
