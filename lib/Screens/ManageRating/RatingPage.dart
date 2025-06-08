import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/RatingController.dart';
import 'package:workshop_management_system/Models/RatingModel.dart';
import 'package:workshop_management_system/Screens/ManageRating/AddRatingPage.dart';
import 'package:workshop_management_system/Screens/ManageRating/EditRatingPage.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}
class _RatingPageState extends State<RatingPage> {
  final Ratingcontroller controller = Ratingcontroller();
  bool isNewSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rating Page')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            // Toggle buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => setState(() => isNewSelected = true),
                    style: TextButton.styleFrom(
                      backgroundColor:
                          isNewSelected ? Colors.blue : Colors.grey[300],
                      foregroundColor:
                          isNewSelected ? Colors.white : Colors.black,
                    ),
                    child: const Text("Foremen Ratings"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    onPressed: () => setState(() => isNewSelected = false),
                    style: TextButton.styleFrom(
                      backgroundColor:
                          !isNewSelected ? Colors.blue : Colors.grey[300],
                      foregroundColor:
                          !isNewSelected ? Colors.white : Colors.black,
                    ),
                    child: const Text("Past Ratings"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Display either workshops or foremen
            Expanded(
                        child: isNewSelected
                            // === Foreman Ratings List ===
                            ? FutureBuilder<List<Map<String, dynamic>>>(
                                future: controller.getForemenByWorkshopOwner(),
                                builder: (ctx, snap) {
                                  if (snap.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  }
                                  if (snap.hasError) {
                                    return Center(child: Text('Error: ${snap.error}'));
                                  }
            
                                  final foremen = snap.data ?? [];
                                  if (foremen.isEmpty) {
                                    return const Center(child: Text('No foremen found.'));
                                  }
            
                                  return ListView.builder(
                                    itemCount: foremen.length,
                                    itemBuilder: (ctx, i) {
                                      final f = foremen[i];
            
                                      final foremanName = f['foremanName'] as String? ?? 'Unknown';
                                      final foremanEmail = f['foremanEmail'] as String? ?? 'No Email';
                                      final foremanPhoneNumber = f['foremanPhoneNumber'] as String? ?? 'No Phone';
                                      final foremanId = f['foremanId'] as String? ?? '';
                                      final ratingMap = f['rating'] as Map<String, dynamic>? ?? {};
                                      final ratingScore = ratingMap['ratingScore'] as int? ?? 0;
            
                                      final schedules = f['WorkshopSchedule'] as List<dynamic>? ?? [];
                                      final jobDescription = schedules.isNotEmpty
                                          ? (schedules[0]['jobDescription'] ?? 'No Description')
                                          : 'No Description';
                                      
                                      return Card(
                                        color: Colors.purple.shade50,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: const Color.fromARGB(255, 25, 148, 111),
                                            child: Text(
                                              foremanName.isNotEmpty ? foremanName[0].toUpperCase() : '?',
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          title: Text(foremanName),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(foremanEmail),
                                              Text(foremanPhoneNumber),
                                              Text(jobDescription),
                                            ],
                                          ),
                                          trailing: ratingScore == 0
                                              ? FilledButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) => AddRatingPage(foremanId: foremanId),
                                                      ),
                                                    ).then((_) => setState(() {})); // refresh after rating
                                                  },
                                                  child: const Text('Rate'),
                                                )
                                              : Text(
                                                  '$ratingScore ★',
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              )
                            // === Workshop Ratings List ===
                            : FutureBuilder<List<Map<String, dynamic>>>(
                                future: controller.getRatedForeman(),
                                builder: (ctx, snap) {
                                  if (snap.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  }
                                  if (snap.hasError) {
                                    return Center(child: Text('Error: ${snap.error}'));
                                  }

                                  final ratedForemen = snap.data ?? [];

                                  if (ratedForemen.isEmpty) {
                                    return const Center(child: Text('No rated foremen found.'));
                                  }

                                  return ListView.builder(
                                    itemCount: ratedForemen.length,
                                    itemBuilder: (ctx, i) {
                                      final f = ratedForemen[i];
                                      final name = '${(f['first_name'] ?? '').toString().trim()} ${(f['last_name'] ?? '').toString().trim()}'.trim();
                                      final ratingScore = f['ratingScore'] ?? '0';
                                      final foremanId = f['foremanId'] ?? '';
                                    
                                      return Card(
                                        color: Colors.blue.shade50,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            child: Text(name.isNotEmpty ? name[0] : '?'),
                                          ),
                                          title: Text(name.isNotEmpty ? name : 'Unknown Foreman'),
                                          subtitle: Text('Given Rating: $ratingScore '),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                 
                                              FilledButton(
                                                child: const Text('Edit'),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => EditRatingPage(
                                                        foremanId: foremanId,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),

                        )
          ],
        ),
      ),
    );
  }
}
