import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workshop_management_system/Screens/Profile/edit_profile_page_workshop_owner.dart';
import 'delete_profile_page_workshop_owner.dart';

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

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    _userDataFuture = fetchUserData();
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('workshop_owner')
            .doc(widget.workshopOwnerId)
            .get();
    return doc.data();
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(value),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workshop Owner Profile'),
        actions: [
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
                  setState(() {
                    _loadUserData();
                  });
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => DeleteProfilePageWorkshopOwner(
                        workshopOwnerId: widget.workshopOwnerId,
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No profile data found.'));
          }

          final userData = snapshot.data!;
          final profileImageUrl = userData['WorkshopProfilePicture'] ?? '';

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        profileImageUrl.isNotEmpty
                            ? NetworkImage(profileImageUrl)
                            : const AssetImage('assets/foreman.png')
                                as ImageProvider,
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
                  _buildInfoTile("Email", userData['email'] ?? '', Icons.email),
                  _buildInfoTile(
                    "Phone Number",
                    userData['phoneNumber'] ?? '',
                    Icons.phone,
                  ),
                ]),
                _buildProfileCard("Workshop Info", [
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
    );
  }
}
