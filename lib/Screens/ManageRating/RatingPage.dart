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

//DUMMY DELETE LATER
class Rating {
  final String? foremanName;
  final String? workshopName;
  final String? comment;
  final int score;

  Rating({
    this.foremanName,
    this.workshopName,
    this.comment,
    required this.score,
  });
}

class _RatingPageState extends State<RatingPage> {
  final Ratingcontroller controller = Ratingcontroller();
  String searchQuery = '';
  bool isNewSelected = true;

  //DUMMY DELETE LATER
  final List<Rating> ratedRatings = [
    Rating(
      foremanName: "Ahmad Albab bin Mahmud",
      workshopName: "Jeng Jeng Jeng Workshop",
      comment: "Very good",
      score: 5,
    ),
    Rating(
      foremanName: "Ali Haidar bin Ali Baba",
      workshopName: "Brother Motorworks",
      comment: "Average service",
      score: 3,
    ),
    Rating(
      foremanName: "Wong Sing Kio",
      workshopName: "Brother Motorworks",
      comment: "",
      score: 4,
    ),
  ];

  final List<Rating> unratedRatings = [
    Rating(
      foremanName: "Ahmad Albab bin Mahmud",
      workshopName: "Foreman",
      score: 0,
      comment: "",
    ),
    Rating(
      foremanName: "ali haidar bin ali baba",
      workshopName: "Foreman",
      score: 0,
      comment: "",
    ),
    Rating(
      foremanName: "Jeng Jeng Jeng Workshop Sdn Bhd",
      workshopName: "Workshop",
      score: 0,
      comment: "",
    ),
    Rating(
      foremanName: "Brother Motorworks Sdn Bhd",
      workshopName: "Workshop",
      score: 0,
      comment: "",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rating Page')),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search foreman and workshop name..',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.trim().toLowerCase();
                  });
                },
              ),
            ),

            //TOGGLE BUTTON TO VIEW NEW
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() => isNewSelected = true);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor:
                          isNewSelected ? Colors.blue : Colors.grey[300],
                      foregroundColor:
                          isNewSelected ? Colors.white : Colors.black,
                    ),
                    child: Text("New"),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() => isNewSelected = false);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor:
                          !isNewSelected ? Colors.blue : Colors.grey[300],
                      foregroundColor:
                          !isNewSelected ? Colors.white : Colors.black,
                    ),
                    child: Text("Rating History"),
                  ),
                ),
              ],
            ),

            Expanded(
              child: Builder(
                builder: (context) {
                  // Choose which list based on the toggle
                  final List<Rating> selectedRatings =
                      isNewSelected ? unratedRatings : ratedRatings;

                  // Then apply your search filter
                  List<Rating> filteredRatings =
                      selectedRatings.where((rating) {
                        final foreman = rating.foremanName?.toLowerCase() ?? '';
                        final workshop =
                            rating.workshopName?.toLowerCase() ?? '';
                        final comment = rating.comment?.toLowerCase() ?? '';
                        return foreman.contains(searchQuery) ||
                            workshop.contains(searchQuery) ||
                            comment.contains(searchQuery);
                      }).toList();

                  if (filteredRatings.isEmpty) {
                    return Center(child: Text('No matching ratings found.'));
                  }

                  return ListView.builder(
                    itemCount: filteredRatings.length,
                    itemBuilder: (context, index) {
                      final r = filteredRatings[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        color: Colors.purple.shade50,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.purple,
                            child: Text(
                              r.foremanName![0].toUpperCase(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(r.foremanName!),
                          subtitle: Text(r.workshopName!),
                          trailing:
                              isNewSelected
                                  // “New” tab shows the rate button
                                  ? FilledButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AddRatingPage(),
                                        ),
                                      );
                                    },
                                    child: Text('rate'),
                                  )
                                  // “History” tab shows the score
                                  : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${r.score} ★',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      FilledButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) =>
                                                      EditRatingPage(), // Reuse or create edit version
                                            ),
                                          );
                                        },
                                        child: Text('Edit'),
                                      ),
                                    ],
                                  ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            /*
            // Ratings List
            Expanded(
              child: StreamBuilder<List<Rating>>(
                stream: controller.getUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No ratings available.'));
                  } else {
                    // Filter ratings by search query on foreman or workshop or comment
                    List<Rating> filteredRatings = snapshot.data!.where((rating) {
                      final foreman = rating.foremanName?.toLowerCase() ?? '';
                      final workshop = rating.workshopName?.toLowerCase() ?? '';
                      final comment = rating.comment?.toLowerCase() ?? '';
                      return foreman.contains(searchQuery) || workshop.contains(searchQuery) || comment.contains(searchQuery);
                    }).toList();

                    if (filteredRatings.isEmpty) {
                      return Center(child: Text('No matching ratings found.'));
                    }

                    return ListView.builder(
                      itemCount: filteredRatings.length,
                      itemBuilder: (context, index) {
                        final rating = filteredRatings[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: Icon(Icons.star, color: Colors.amber),
                            title: Text(rating.foremanName ?? 'Unknown Foreman'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Workshop: ${rating.workshopName ?? 'Unknown Workshop'}'),
                                if ((rating.comment ?? '').isNotEmpty) Text('Comment: ${rating.comment}'),
                              ],
                            ),
                            trailing: Text(
                              rating.score.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            */
          ],
        ),
      ),
    );
  }
}
