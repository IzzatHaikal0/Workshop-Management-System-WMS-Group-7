import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/RatingController.dart';
import 'package:workshop_management_system/Models/RatingModel.dart';
import 'package:workshop_management_system/Screens/ManageRating/RatingPage.dart';

class EditRatingPage extends StatefulWidget {
  const EditRatingPage({super.key});

  @override
  State<EditRatingPage> createState() => _EditRatingPageState();
}

class _EditRatingPageState extends State<EditRatingPage> {
  final Ratingcontroller controller = Ratingcontroller();
  int ratingScore = 0;
  String reviewComment = '';
  int ratingID = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Rating')),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            // Rating Score
            Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text('User Name'),
                    Text('Ahmad Labu bin Ahmad John')
                  ],
                ),
              ),
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: _onCancel,
                  label: Text('Cancel', style: TextStyle(color: Colors.red)),
                ),
                OutlinedButton.icon(
                  onPressed: _onSave,
                  label: Text('Save', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onCancel() {
    Navigator.pop(
      context,
      MaterialPageRoute(builder: (context) => RatingPage()),
    );
  }

  void _onSave() {
    /*RatingModel rating = RatingModel(
      ratingID: ratingID,
      ratingScore: ratingScore,
      reviewComment: reviewComment,
    );
    controller.addRating(rating);*/
    Navigator.pop(
      context,
      MaterialPageRoute(builder: (context) => RatingPage()),
    );
  }
}
