import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/RatingController.dart';
import 'package:workshop_management_system/Models/RatingModel.dart';
import 'package:workshop_management_system/Models/foreman_model.dart';

class ForemanPage extends StatefulWidget {
  final String foremanId;
  const ForemanPage({super.key, required this.foremanId});

  @override
  State<ForemanPage> createState() => _ForemanPageState();
}

class _ForemanPageState extends State<ForemanPage> {
  final Ratingcontroller controller = Ratingcontroller();

  double averageRating = 0.0;
  double highestRating = 0.0;
  List<Rating> pastRatings = [];

  ForemanModel? foremanProfile;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await controller.loadRatingsForForeman(widget.foremanId);
    final profile = await controller.getForemanProfile(widget.foremanId);

    setState(() {
      pastRatings = result['ratings'];
      averageRating = (result['average'] as num).toDouble();
      highestRating = (result['highest'] as num).toDouble();
      foremanProfile = profile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Ratings')),
      body:
          foremanProfile == null
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                "My Ratings and Review",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 16),

                             Center(
                              child: Card(
                                color: Colors.blue.shade100,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: SizedBox(
                                  width: constraints.maxHeight * 0.25, // Same as height for a square
                                  height: constraints.maxHeight * 0.25,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          "${foremanProfile!.firstName} ${foremanProfile!.lastName}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          foremanProfile!.email,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          foremanProfile!.phoneNumber,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                              const SizedBox(height: 16),

                              /// Ratings boxes
                              SizedBox(
                                height: constraints.maxHeight * 0.2,
                                child: Row(
                                  children: [
                                    _buildRatingBox(
                                      "Average Rating",
                                      averageRating,
                                    ),
                                    const SizedBox(width: 16),
                                    _buildRatingBox(
                                      "Highest Rating",
                                      highestRating,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),
                              const Text(
                                "Past Ratings",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),

                              /// Past Ratings List
                              Expanded(
                                child:
                                    pastRatings.isEmpty
                                        ? const Center(
                                          child: Text("No ratings found"),
                                        )
                                        : ListView.builder(
                                          itemCount: pastRatings.length,
                                          itemBuilder: (context, index) {
                                            final rating = pastRatings[index];
                                            return Card(
                                              color: Colors.purple.shade50,
                                              child: ListTile(
                                                leading: const CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  child: Icon(
                                                    Icons.add_task_rounded,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                title: Text(
                                                  rating.reviewComment,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: const Text(
                                                  "Workshop",
                                                ),
                                                trailing: Text(
                                                  rating.ratingScore
                                                      .toStringAsFixed(1),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
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

  Widget _buildRatingBox(String title, double score) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Text(
              score.toStringAsFixed(1),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
