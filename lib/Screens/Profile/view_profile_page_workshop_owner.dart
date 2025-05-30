import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workshop_management_system/Screens/Profile/add_profile_page_workshop_owner.dart';
import 'package:workshop_management_system/Screens/Profile/edit_profile_page_workshop_owner.dart';
import '../welcome_screen.dart';

class ViewProfilePageWorkshopOwner extends StatefulWidget {
  final String workshopOwnerId;

  const ViewProfilePageWorkshopOwner({
    super.key,
    required this.workshopOwnerId,
  });

  @override
  State<ViewProfilePageWorkshopOwner> createState() =>
      _ViewProfilePageWorkshopOwnerState();
}

class _ViewProfilePageWorkshopOwnerState
    extends State<ViewProfilePageWorkshopOwner> {
  late Future<Map<String, dynamic>?> _userDataFuture;

  static const _iconColor = Colors.blueAccent;
  static const _cardRadius = 12.0;
  static const _cardElevation = 4.0;
  static const _padding = EdgeInsets.all(16);

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
              .collection('workshop_owner')
              .doc(widget.workshopOwnerId)
              .get();
      return doc.data();
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      return null;
    }
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      leading: Icon(icon, color: _iconColor),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(value.isNotEmpty ? value : '-'),
    );
  }

  Widget _buildProfileSection(String title, List<Widget> children) {
    return Card(
      elevation: _cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cardRadius),
      ),
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

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Profile'),
            content: const Text(
              'Are you sure you want to delete this profile?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Perform delete operation here
                  try {
                    await FirebaseFirestore.instance
                        .collection('workshop_owner')
                        .doc(widget.workshopOwnerId)
                        .delete();

                    // After delete, close dialog with true
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, true);
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, false);
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Delete failed: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      // Navigate to WelcomeScreen and clear all previous routes
      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (_) => WelcomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workshop Owner Profile'),
        actions: [
          IconButton(
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
                        (_) => AddProfilePageWorkshopOwner(
                          workshopOwnerId: widget.workshopOwnerId,
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
          IconButton(
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
                        (_) => EditProfilePageWorkshopOwner(
                          workshopOwnerId: widget.workshopOwnerId,
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
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete Profile',
            onPressed: _confirmDelete,
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
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No profile data found.'));
            }

            final userData = snapshot.data!;
            final profileImageUrl = userData['WorkshopProfilePicture'] ?? '';

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: _padding,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage:
                        profileImageUrl.isNotEmpty
                            ? NetworkImage(profileImageUrl)
                            : const AssetImage('assets/foreman.png')
                                as ImageProvider,
                    backgroundColor: Colors.grey.shade200,
                  ),
                  const SizedBox(height: 24),
                  _buildProfileSection("Personal Info", [
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
                      "Phone",
                      userData['phoneNumber'] ?? '',
                      Icons.phone,
                    ),
                  ]),
                  _buildProfileSection("Workshop Info", [
                    _buildInfoTile(
                      "Workshop Name",
                      userData['workshopName'] ?? '',
                      Icons.business,
                    ),
                    _buildInfoTile(
                      "Address",
                      userData['workshopAddress'] ?? '',
                      Icons.location_on,
                    ),
                    _buildInfoTile(
                      "Phone",
                      userData['workshopPhone'] ?? '',
                      Icons.phone_android,
                    ),
                    _buildInfoTile(
                      "Email",
                      userData['workshopEmail'] ?? '',
                      Icons.email_outlined,
                    ),
                    _buildInfoTile(
                      "Operation Hours",
                      userData['workshopOperationHour'] ?? '',
                      Icons.access_time,
                    ),
                    _buildInfoTile(
                      "Description",
                      userData['workshopDetail'] ?? '',
                      Icons.description,
                    ),
                  ]),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
