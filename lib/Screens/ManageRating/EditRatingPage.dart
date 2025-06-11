import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/RatingController.dart';
import 'package:workshop_management_system/Models/RatingModel.dart';
import 'package:workshop_management_system/Screens/ManageRating/RatingPage.dart';

class EditRatingPage extends StatefulWidget {
  final String foremanId;
  final String docId;
  const EditRatingPage({super.key, required this.foremanId, required this.docId});

  @override
  State<EditRatingPage> createState() => _EditRatingPageState();
}

class _EditRatingPageState extends State<EditRatingPage> {
  final Ratingcontroller controller = Ratingcontroller();

  Map<String, dynamic>? foremanData;
  bool isLoading = true;

  int ratingScore = 0;
  String reviewComment = '';
  String serviceType = '';

  late TextEditingController reviewCommentController;
  late TextEditingController serviceTypeController;

  @override
  void initState() {
    super.initState();
    reviewCommentController = TextEditingController();
    serviceTypeController = TextEditingController(); 

    _loadData();
  }

  Future<void> _loadData() async {
    // Fetch foreman data
    final foreman = await controller.getForemanWithSchedule(widget.foremanId);

    // Fetch rating data
    final rating = await controller.getRatingById(widget.docId);

    setState(() {
      foremanData = foreman;

      if (rating != null) {
        ratingScore = rating.ratingScore;
        reviewComment = rating.reviewComment;
        serviceType = rating.serviceType;

        reviewCommentController.text = reviewComment;
        serviceTypeController.text = serviceType;
      }

      isLoading = false;
    });
  }

  @override
  void dispose() {
    reviewCommentController.dispose();
    serviceTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Rating')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Rating')),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (foremanData != null)
              Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color.fromARGB(255, 25, 148, 111),
                          radius: 70,
                          child: Text(
                            (foremanData!['firstName'] as String).isNotEmpty
                                ? (foremanData!['firstName'][0] as String).toUpperCase()
                                : '?',
                            style: const TextStyle(color: Colors.white, fontSize: 50),
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Foreman Information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Name: ${foremanData!['firstName']} ${foremanData!['lastName']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Email: ${foremanData!['email']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Phone: ${foremanData!['phoneNumber']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                title: Text('Rating Score'),
                subtitle: Slider(
                  value: ratingScore.toDouble(),
                  min: 0,
                  max: 5,
                  divisions: 5,
                  label: ratingScore.toString(),
                  onChanged: (double value) {
                    setState(() {
                      ratingScore = value.toInt();
                    });
                  },
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Review Comment'),
                subtitle: TextField(
                  controller: reviewCommentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (value) {
                    setState(() {
                      reviewComment = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your review comment',
                  ),
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Service Type Provided'),
                subtitle: TextField(
                  controller: serviceTypeController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (value) {
                    setState(() {
                      serviceType = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the service type provided',
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: _onCancel,
                  label: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                  icon: Icon(Icons.cancel, color: Colors.red),
                ),
                OutlinedButton.icon(
                  onPressed: _onSave,
                  label: Text(
                    'Save',
                    style: TextStyle(color: Colors.blue),
                  ),
                  icon: Icon(Icons.save, color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  void _onSave() async {
    if (ratingScore > 0 && serviceType.isNotEmpty) {
      final rating = Rating(
        foremanId: widget.foremanId,
        ratingScore: ratingScore,
        reviewComment: reviewComment,
        serviceType: serviceType,
        ratingDate: DateTime.now().toIso8601String(),
        docId: widget.docId, // Include the document ID for updates
      );

      await controller.editRating(rating);

      Navigator.pop(context, true); // Pass true to indicate saved/updated
    }
  }
}
