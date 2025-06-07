import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/RatingController.dart';
import 'package:workshop_management_system/Models/RatingModel.dart';
import 'package:workshop_management_system/Screens/ManageRating/AddRatingPage.dart';
import 'package:workshop_management_system/Screens/ManageRating/EditRatingPage.dart';

class ForemanPage extends StatefulWidget {
  const ForemanPage({super.key});

  @override
  State<ForemanPage> createState() => _ForemanPageState();
}

class _ForemanPageState extends State<ForemanPage> {
  final Ratingcontroller controller = Ratingcontroller();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Manage Ratings')));
  }
}
