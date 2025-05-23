import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfilePageForeman extends StatefulWidget {
  final String foremanId;
  final Map<String, dynamic> existingProfile;

  const EditProfilePageForeman({
    Key? key,
    required this.foremanId,
    required this.existingProfile,
  }) : super(key: key);

  @override
  State<EditProfilePageForeman> createState() => _EditProfilePageForemanState();
}

class _EditProfilePageForemanState extends State<EditProfilePageForeman> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _foremanAddressController;
  late final TextEditingController _foremanSkillsController;
  late final TextEditingController _foremanWorkExperienceController;

  String? _profileImageUrl;
  File? _pickedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final data = widget.existingProfile;

    _firstNameController = TextEditingController(
      text: data['first_name'] ?? '',
    );
    _lastNameController = TextEditingController(text: data['last_name'] ?? '');
    _emailController = TextEditingController(text: data['email'] ?? '');
    _phoneNumberController = TextEditingController(
      text: data['phone_number'] ?? '',
    );
    _foremanAddressController = TextEditingController(
      text: data['foremanAddress'] ?? '',
    );
    _foremanSkillsController = TextEditingController(
      text: data['foremanSkills'] ?? '',
    );
    _foremanWorkExperienceController = TextEditingController(
      text: data['foremanWorkExperience'] ?? '',
    );
    _profileImageUrl = data['foremanProfilePicture'];
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      setState(() => _pickedImage = File(pickedFile.path));
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('New image selected')));
      }
    }
  }

  Future<String?> _uploadProfileImage(String userId) async {
    if (_pickedImage == null) return _profileImageUrl;
    final ref = FirebaseStorage.instance.ref().child(
      'foremen/$userId/profile.jpg',
    );
    await ref.putFile(_pickedImage!);
    return await ref.getDownloadURL();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final imageUrl = await _uploadProfileImage(widget.foremanId);
      await FirebaseFirestore.instance
          .collection('foremen')
          .doc(widget.foremanId)
          .update({
            'first_name': _firstNameController.text.trim(),
            'last_name': _lastNameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone_number': _phoneNumberController.text.trim(),
            'foremanAddress': _foremanAddressController.text.trim(),
            'foremanSkills': _foremanSkillsController.text.trim(),
            'foremanWorkExperience':
                _foremanWorkExperienceController.text.trim(),
            'foremanProfilePicture': imageUrl,
          });

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile updated')));
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _foremanAddressController.dispose();
    _foremanSkillsController.dispose();
    _foremanWorkExperienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ImageProvider<Object>? profileImage =
        _pickedImage != null
            ? FileImage(_pickedImage!)
            : (_profileImageUrl != null
                ? NetworkImage(_profileImageUrl!)
                : null);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Foreman Profile')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: profileImage,
                                child:
                                    profileImage == null
                                        ? const Icon(
                                          Icons.add_a_photo,
                                          size: 40,
                                        )
                                        : null,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _pickedImage != null
                                  ? 'New image selected. Will be uploaded when you save.'
                                  : 'Tap to change profile picture',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Required'
                                    : null,
                      ),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Required'
                                    : null,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegex.hasMatch(value))
                            return 'Invalid email';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _phoneNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                        ),
                        keyboardType: TextInputType.phone,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Required'
                                    : null,
                      ),
                      TextFormField(
                        controller: _foremanAddressController,
                        decoration: const InputDecoration(labelText: 'Address'),
                        keyboardType: TextInputType.streetAddress,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Required'
                                    : null,
                      ),
                      TextFormField(
                        controller: _foremanSkillsController,
                        decoration: const InputDecoration(labelText: 'Skills'),
                        maxLines: 2,
                      ),
                      TextFormField(
                        controller: _foremanWorkExperienceController,
                        decoration: const InputDecoration(
                          labelText: 'Work Experience',
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _saveProfile,
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
