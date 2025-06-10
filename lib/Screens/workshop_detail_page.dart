// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

class WorkshopDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const WorkshopDetailPage({super.key, required this.data});

  Widget sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[800],
        ),
      ),
    );
  }

  Widget infoRow(
    IconData icon,
    String label,
    String value,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String workshopName = data['workshopName'] ?? 'Unnamed Workshop';
    final String firstName = data['firstName'] ?? '';
    final String lastName = data['lastName'] ?? '';
    final String email = data['email'] ?? '';
    final String phoneNumber = data['phoneNumber'] ?? '';
    final String workshopAddress = data['workshopAddress'] ?? 'No address';
    final String workshopPhone = data['workshopPhone'] ?? 'N/A';
    final String workshopEmail = data['workshopEmail'] ?? 'N/A';
    final String workshopOperationHour = data['workshopOperationHour'] ?? 'N/A';
    final String workshopDetail =
        data['workshopDetail'] ?? 'No details available.';
    final String? profilePictureUrl = data['workshopProfilePicture'];

    return Scaffold(
      appBar: AppBar(title: Text(workshopName), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundImage:
                    profilePictureUrl != null
                        ? NetworkImage(profilePictureUrl)
                        : null,
                child:
                    profilePictureUrl == null
                        ? const Icon(
                          Icons.store,
                          size: 70,
                          color: Colors.white70,
                        )
                        : null,
                backgroundColor: Colors.blueGrey.shade200,
              ),
            ),
            const SizedBox(height: 20),

            Center(
              child: Text(
                workshopName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),

            Card(
              elevation: 3,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionTitle(context, 'Owner Information'),
                    infoRow(
                      Icons.person,
                      'Name',
                      '$firstName $lastName',
                      context,
                    ),
                    infoRow(Icons.email, 'Email', email, context),
                    infoRow(Icons.phone, 'Phone', phoneNumber, context),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 3,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionTitle(context, 'Workshop Contact'),
                    infoRow(
                      Icons.location_on,
                      'Address',
                      workshopAddress,
                      context,
                    ),
                    infoRow(
                      Icons.phone_android,
                      'Phone',
                      workshopPhone,
                      context,
                    ),
                    infoRow(
                      Icons.email_outlined,
                      'Email',
                      workshopEmail,
                      context,
                    ),
                    infoRow(
                      Icons.access_time,
                      'Operation Hours',
                      workshopOperationHour,
                      context,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 3,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionTitle(context, 'Details'),
                    Text(
                      workshopDetail,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}