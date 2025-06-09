import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/RatingController.dart';
import 'package:workshop_management_system/Models/RatingModel.dart';
import 'package:workshop_management_system/Screens/ManageRating/RatingPage.dart';

class AddRatingPage extends StatefulWidget {
  final String foremanId;
  final String scheduleDocId;

  const AddRatingPage({super.key, required this.foremanId, required this.scheduleDocId});

  @override
  State<AddRatingPage> createState() => _AddRatingPageState();
}

class _AddRatingPageState extends State<AddRatingPage> {
  final Ratingcontroller controller = Ratingcontroller();

  Map<String, dynamic>? foremanData;
  bool isLoading = true;

  int ratingScore = 0;
  String reviewComment = '';
  String serviceType = '';

  @override
  void initState() {
    super.initState();
    _fetchForemanData();
  }

  Future<void> _fetchForemanData() async {
    final data = await controller.getForemanWithSchedule(widget.foremanId);
    setState(() {
      foremanData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Rating')),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                  (foremanData!['first_name'] as String).isNotEmpty
                                      ? (foremanData!['first_name'][0] as String).toUpperCase()
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
                                'Name: ${foremanData!['first_name']} ${foremanData!['last_name']}',
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
                                'Phone: ${foremanData!['phone_number']}',
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
                        ),
                        OutlinedButton.icon(
                          onPressed: _onSave,
                          label: Text(
                            'Save',
                            style: TextStyle(color: Colors.blue),
                          ),
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

        );

        await controller.addRating(rating, widget.scheduleDocId);

        Navigator.pop(
          context, 
          MaterialPageRoute(builder: (context) => RatingPage())); 
      }
    }


}
