import 'package:flutter/material.dart';
import '../../main.dart'; // AppRoutes import if needed

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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Color(0xFF4169E1), // Royal Blue
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Select Registration Type'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/workshop_logo.webp',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 20),
              const Text(
                'Register as:',
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => navigateToForm(context, 'Workshop Owner'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 33, 150, 243),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Workshop Owner',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => navigateToForm(context, 'Foreman'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Foreman',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
