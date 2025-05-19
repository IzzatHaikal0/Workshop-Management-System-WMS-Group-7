import 'package:flutter/material.dart';
import 'register_form.dart';

class RegisterType extends StatelessWidget {
  const RegisterType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Registration Type")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegisterForm(userRole: "Foreman"),
                    ),
                  ),
              child: Text("Register as Foreman"),
            ),
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegisterForm(userRole: "Workshop Owner"),
                    ),
                  ),
              child: Text("Register as Workshop Owner"),
            ),
          ],
        ),
      ),
    );
  }
}
