import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workshop_management_system/Screens/Profile/add_profile_page_foreman.dart';
import 'package:workshop_management_system/Screens/Profile/edit_profile_page_foreman.dart';

// Import your WelcomeScreen here
import 'package:workshop_management_system/Screens/welcome_screen.dart'; // Adjust path as needed

class ViewProfilePageForeman extends StatefulWidget {
  final String foremanId;

  const ViewProfilePageForeman({super.key, required this.foremanId});

  @override
  State<ViewProfilePageForeman> createState() => _ViewProfilePageForemanState();
}

class _ViewProfilePageForemanState extends State<ViewProfilePageForeman> {
  late Future<Map<String, dynamic>?> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    setState(() {
      _userDataFuture = fetchUserData();
    });
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('foremen')
              .doc(widget.foremanId)
              .get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching foreman data: $e');
      return null;
    }
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(value.isNotEmpty ? value : 'Not provided'),
    );
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

  Future<bool?> _confirmDelete() async {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Profile'),
            content: const Text(
              'Are you sure you want to delete this profile? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  void _handleDelete() async {
    final confirmed = await _confirmDelete();
    if (confirmed == true) {
      try {
        await FirebaseFirestore.instance
            .collection('foremen')
            .doc(widget.foremanId)
            .delete();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile deleted successfully.'),
              backgroundColor: Colors.green,
            ),
          );
          Future.delayed(const Duration(seconds: 1), () {
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => WelcomeScreen()),
              (route) => false,
            );
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete profile: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foreman Profile'),
        actions: [
          Semantics(
            label: 'Add Foreman Profile',
            child: IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add Profile',
              onPressed: () async {
                final userData = await fetchUserData();
                if (userData != null) {
                  final updated = await Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => AddProfilePageForeman(
                            foremanId: widget.foremanId,
                            existingProfile: userData,
                          ),
                    ),
                  );
                  if (updated == true) {
                    _loadUserData();
                  }
                }
              },
            ),
          ),
          Semantics(
            label: 'Edit Foreman Profile',
            child: IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Profile',
              onPressed: () async {
                final userData = await fetchUserData();
                if (userData != null) {
                  final updated = await Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => EditProfilePageForeman(
                            foremanId: widget.foremanId,
                            existingProfile: userData,
                          ),
                    ),
                  );
                  if (updated == true) {
                    _loadUserData();
                  }
                }
              },
            ),
          ),
          Semantics(
            label: 'Delete Foreman Profile',
            child: IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete Profile',
              onPressed: _handleDelete,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadUserData();
          await _userDataFuture;
        },
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading profile data: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No profile data found.'));
            }

            final userData = snapshot.data!;
            final profileImageUrl =
                (userData['ForemanProfilePicture'] ?? '') as String;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        profileImageUrl.isNotEmpty
                            ? NetworkImage(profileImageUrl)
                            : const AssetImage('assets/foreman.png')
                                as ImageProvider,
                    onBackgroundImageError: (_, __) {
                      // Handle image loading error if needed
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _buildProfileCard("Personal Info", [
                  _buildInfoTile(
                    "First Name",
                    userData['first_name'] ?? '',
                    Icons.person,
                  ),
                  _buildInfoTile(
                    "Last Name",
                    userData['last_name'] ?? '',
                    Icons.person_outline,
                  ),
                  _buildInfoTile("Email", userData['email'] ?? '', Icons.email),
                  _buildInfoTile(
                    "Phone Number",
                    userData['phone_number'] ?? '',
                    Icons.phone,
                  ),
                  _buildInfoTile(
                    "Address",
                    userData['foremanAddress'] ?? '',
                    Icons.home,
                  ),
                ]),
                _buildProfileCard("Professional Info", [
                  _buildInfoTile(
                    "Skills",
                    userData['foremanSkills'] ?? '',
                    Icons.build,
                  ),
                  _buildInfoTile(
                    "Work Experience",
                    userData['foremanWorkExperience'] ?? '',
                    Icons.work_history,
                  ),
                ]),
              ],
            );
          },
        ),
      ),
    );
  }
}
