import 'package:flutter/material.dart';
import 'confirmation_dialog.dart';
import 'registration_success_page.dart';

class RegisterForm extends StatefulWidget {
  final String userRole;
  const RegisterForm({super.key, required this.userRole});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String firstName = '', lastName = '', email = '', phone = '', password = '';

  get controller => null;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      bool confirmed = await showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(),
      );

      if (confirmed) {
        await controller.registerUser(
          role: widget.userRole,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phone,
          password: password,
        );
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (_) => RegistrationSuccessPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register as ${widget.userRole}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "First Name"),
                onChanged: (value) => firstName = value,
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Last Name"),
                onChanged: (value) => lastName = value,
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (value) => email = value,
                validator:
                    (value) =>
                        value!.contains('@') ? null : "Enter valid email",
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Phone Number"),
                onChanged: (value) => phone = value,
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
                onChanged: (value) => password = value,
                validator:
                    (value) =>
                        value!.length < 6 ? "Minimum 6 characters" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: Text("Register")),
            ],
          ),
        ),
      ),
    );
  }
}
