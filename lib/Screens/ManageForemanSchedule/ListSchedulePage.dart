// ListSchedulePage.dart
import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule Page')),
      body: Center(
        child: const Text('This is the Schedule Page'),
      ),
    );
  }
}
