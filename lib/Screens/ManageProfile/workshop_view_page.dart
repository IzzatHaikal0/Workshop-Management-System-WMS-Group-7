import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workshop_management_system/Screens/ManageProfile/workshop_add_page.dart';
import 'package:workshop_management_system/Screens/ManageProfile/workshop_edit_page.dart';
import 'package:workshop_management_system/main.dart';
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
              'Are you sure you want to delete this profile? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseFirestore.instance
                        .collection('workshop_owner')
                        .doc(widget.workshopOwnerId)
                        .delete();
                    Navigator.pop(context, true);
                  } catch (e) {
                    Navigator.pop(context, false);
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
      Navigator.pushAndRemoveUntil(
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
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4169E1)),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => MyApp()),
              (route) => false,
            );
          },
        ),
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
                      "Owner Phone Number",
                      userData['phoneNumber'] ?? '',
                      Icons.phone,
                    ),
                  ]),
                  _buildProfileSection("Workshop Info", [
                    _buildInfoTile(
                      "Workshop Name",
                      userData['workshopName'] ?? '',
                      Icons.home_repair_service,
                    ),
                    _buildInfoTile(
                      "Workshop Address",
                      userData['workshopAddress'] ?? '',
                      Icons.location_on,
                    ),
                    _buildInfoTile(
                      "Workshop Phone",
                      userData['workshopPhone'] ?? '',
                      Icons.phone_android,
                    ),
                    _buildInfoTile(
                      "Workshop Email",
                      userData['workshopEmail'] ?? '',
                      Icons.email_outlined,
                    ),
                    _buildInfoTile(
                      "Workshop Operation Hours",
                      userData['workshopOperationHour'] ?? '',
                      Icons.access_time,
                    ),
                    _buildInfoTile(
                      "Workshop Detail",
                      userData['workshopDetail'] ?? '',
                      Icons.description,
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Add Profile',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final userData = await fetchUserData();
                          if (userData != null) {
                            final updated = await Navigator.push(
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _confirmDelete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Delete Profile',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
