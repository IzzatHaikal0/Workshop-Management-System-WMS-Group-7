import 'package:flutter/material.dart';
import 'package:workshop_management_system/controllers/registration_controller.dart';
import '../Registration/widgets/confirmation_dialog.dart';
import '../../main.dart'; // import AppRoutes

class RegisterForm extends StatefulWidget {
  final String userRole;
  const RegisterForm({super.key, required this.userRole});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final RegistrationController _controller = RegistrationController();

  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      bool confirmed = await showDialog(
        context: context,
        builder:
            (_) => const ConfirmationDialog(
              title: 'Confirm Registration',
              content: 'Are you sure you want to submit your registration?',
            ),
      );

      if (confirmed) {
        setState(() {
          _isSubmitting = true;
        });

        final user = _controller.createUser(
          role: widget.userRole,
          firstName: _firstNameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          phoneNumber: _phoneCtrl.text.trim(),
          password: _passwordCtrl.text.trim(),
        );

        bool saved = await _controller.saveUser(user);

        setState(() {
          _isSubmitting = false;
        });

        if (saved) {
          if (mounted) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.registrationSuccess,
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to save registration data.'),
              ),
            );
          }
        }
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon,
        ),
        obscureText: obscureText,
        validator: validator,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register as ${widget.userRole}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              _buildTextField(
                controller: _firstNameCtrl,
                label: 'First Name *',
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
              ),
              _buildTextField(
                controller: _lastNameCtrl,
                label: 'Last Name *',
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
              ),
              _buildTextField(
                controller: _emailCtrl,
                label: 'Email *',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                  if (!emailRegex.hasMatch(value)) return 'Invalid email';
                  return null;
                },
              ),
              _buildTextField(
                controller: _phoneCtrl,
                label: 'Phone Number *',
                keyboardType: TextInputType.phone,
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
              ),
              _buildTextField(
                controller: _passwordCtrl,
                label: 'Password *',
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (value.length < 6) return 'Minimum 6 characters';
                  return null;
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  child:
                      _isSubmitting
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text('Submit Registration'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
