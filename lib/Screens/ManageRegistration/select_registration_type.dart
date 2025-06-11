import 'package:flutter/material.dart';
// you can keep this or remove if not used directly
import '../../main.dart'; // import AppRoutes or create a separate routes.dart if preferred

class RegisterType extends StatelessWidget {
  const RegisterType({super.key});

  void navigateToForm(BuildContext context, String role) {
    Navigator.pushNamed(
      context,
      AppRoutes.registerForm,
      arguments: {'userRole': role},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Registration Type')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Register as:', style: TextStyle(fontSize: 22)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => navigateToForm(context, 'Workshop Owner'),
                child: const Text('Workshop Owner'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => navigateToForm(context, 'Foreman'),
                child: const Text('Foreman'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
