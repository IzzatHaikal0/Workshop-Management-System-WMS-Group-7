import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workshop_management_system/Screens/ManageProfile/foreman_add_page.dart';
import 'package:workshop_management_system/Screens/ManageProfile/foreman_edit_page.dart';
import 'package:workshop_management_system/Screens/welcome_screen.dart';
import 'package:workshop_management_system/main.dart';

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
      return doc.exists ? doc.data() : null;
    } catch (e) {
      debugPrint('Error fetching foreman data: $e');
      return null;
    }
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value.isNotEmpty ? value : 'Not provided'),
      ),
    );
  }

  Widget _buildProfileCard(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
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
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
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
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
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

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                backgroundColor: Colors.white,
                centerTitle: true,
                title: const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF4169E1),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const MyApp()),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue.shade100,
                        child:
                            profileImageUrl.isNotEmpty
                                ? ClipOval(
                                  child: Image.network(
                                    profileImageUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.blue,
                                ),
                      ),
                      const SizedBox(height: 16),
                      _buildProfileCard("Personal Info", [
                        _buildInfoTile(
                          "First Name",
                          userData['firstName'] ?? '',
                          Icons.person,
                        ),
                        _buildInfoTile(
                          "Last Name",
                          userData['lastName'] ?? '',
                          Icons.person_outline,
                        ),
                        _buildInfoTile(
                          "Email",
                          userData['email'] ?? '',
                          Icons.email,
                        ),
                        _buildInfoTile(
                          "Phone Number",
                          userData['phoneNumber'] ?? '',
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
                          Icons.handyman,
                        ),
                        _buildInfoTile(
                          "Work Experience",
                          userData['foremanWorkExperience'] ?? '',
                          Icons.work_history,
                        ),
                      ]),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final userData = await fetchUserData();
                              if (userData != null) {
                                final updated = await Navigator.push(
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Add Profile'),
                          ),
                          ElevatedButton(
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Edit Profile'),
                          ),
                          ElevatedButton(
                            onPressed: _handleDelete,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Delete Profile'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
