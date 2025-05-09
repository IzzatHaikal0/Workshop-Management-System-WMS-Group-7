import 'package:flutter/material.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../controllers/registration_controller.dart';
import '../../../utils/validators.dart';

class WorkshopOwnerRegisterPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _controller = RegistrationController();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  WorkshopOwnerRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Workshop Owner Registration')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(controller: _nameController, label: 'Name'),
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                validator: Validators.validateEmail,
              ),
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
              ),
              SizedBox(height: 20),
              CustomButton(
                label: 'Register',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _controller.registerWorkshopOwner(
                      _nameController.text,
                      _emailController.text,
                      _passwordController.text,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Registered Successfully')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
