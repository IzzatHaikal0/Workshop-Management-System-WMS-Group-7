import 'package:flutter/material.dart';
import '../../main.dart'; // For AppRoutes

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                const Text(
                  'Workshop Management\nSystem',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 30),

                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'assets/images/workshop_logo.webp',
                    width: 200,
                    height: 200,
                    semanticLabel: 'Workshop logo',
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Login", style: TextStyle(fontSize: 16)),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Don't have an account?",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),

                const SizedBox(height: 10),

                OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.registerType);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Create an account",
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),

                const SizedBox(height: 40), // Extra bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }
}
