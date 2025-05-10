import 'package:flutter/material.dart';
import 'foreman_register_page.dart';
import 'workshop_owner_register_page.dart';
import '../../main.dart'; // Import MyHomePage

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Role Selection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Choose your role',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ForemanRegisterPage(userRole: 'Foreman'),
                  ),
                );
              },
              child: const Text('Foreman'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WorkshopOwnerRegisterPage(userRole: 'Workshop Owner'),
                  ),
                );
              },
              child: const Text('Workshop Owner'),
            ),
            const SizedBox(height: 40),
            // Extra: Direct skip to main app (for testing)
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const MyHomePage(title: 'Workshop Management System'),
                  ),
                );
              },
              child: const Text('Back to Homepage'),
            ),
          ],
        ),
      ),
    );
  }
}
