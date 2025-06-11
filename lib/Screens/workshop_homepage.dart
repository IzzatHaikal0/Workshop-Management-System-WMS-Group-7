import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'workshop_detail_page.dart'; // Ensure this file exists

class WorkshopHomePage extends StatefulWidget {
  const WorkshopHomePage({super.key});

  @override
  State<WorkshopHomePage> createState() => _WorkshopHomePageState();
}

class _WorkshopHomePageState extends State<WorkshopHomePage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Workshops'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search workshops...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // 📋 Workshop List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('workshop_owner')
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No workshop owners found.'));
                }

                // Filter + sort by rating
                final filteredOwners =
                    snapshot.data!.docs
                        .map((doc) => doc.data() as Map<String, dynamic>)
                        .where((data) {
                          final name =
                              data['workshopName']?.toLowerCase() ?? '';
                          return name.contains(searchQuery);
                        })
                        .toList()
                      ..sort(
                        (a, b) =>
                            (b['rating'] ?? 0).compareTo(a['rating'] ?? 0),
                      );

                if (filteredOwners.isEmpty) {
                  return const Center(
                    child: Text('No workshops match your search.'),
                  );
                }

                return ListView.builder(
                  itemCount: filteredOwners.length,
                  itemBuilder: (context, index) {
                    final data = filteredOwners[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🖼️ Profile Image
                            CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  data['workshopProfilePicture'] != null
                                      ? NetworkImage(
                                        data['workshopProfilePicture'],
                                      )
                                      : null,
                              child:
                                  data['workshopProfilePicture'] == null
                                      ? const Icon(Icons.store)
                                      : null,
                            ),
                            const SizedBox(width: 16),

                            // 📝 Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['workshopName'] ?? 'Unnamed Workshop',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(data['workshopAddress'] ?? 'No address'),
                                  Text(
                                    'Phone: ${data['workshopPhone'] ?? 'N/A'}',
                                  ),
                                  const SizedBox(height: 4),
                                  if (data['rating'] != null)
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${data['rating']}/5',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 8),

                                  // 🔗 See More Link
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => WorkshopDetailPage(
                                                data: data,
                                              ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'See More',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
