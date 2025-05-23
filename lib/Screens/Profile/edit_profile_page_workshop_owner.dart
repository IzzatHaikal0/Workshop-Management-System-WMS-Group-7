import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfilePageWorkshopOwner extends StatefulWidget {
  final String workshopOwnerId;
  final Map<String, dynamic> existingProfile;

  const EditProfilePageWorkshopOwner({
    super.key,
    required this.workshopOwnerId,
    required this.existingProfile,
  });

  @override
  State<EditProfilePageWorkshopOwner> createState() =>
      _EditProfilePageWorkshopOwnerState();
}

class _EditProfilePageWorkshopOwnerState
    extends State<EditProfilePageWorkshopOwner> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _workshopNameController;
  late final TextEditingController _workshopAddressController;
  late final TextEditingController _workshopPhoneController;
  late final TextEditingController _workshopEmailController;
  late final TextEditingController _workshopOperationHourController;
  late final TextEditingController _workshopDetailController;

  String? _profileImageUrl;
  File? _pickedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final data = widget.existingProfile;
    _firstNameController = TextEditingController(text: data['firstName'] ?? '');
    _lastNameController = TextEditingController(text: data['lastName'] ?? '');
    _emailController = TextEditingController(text: data['email'] ?? '');
    _phoneNumberController = TextEditingController(
      text: data['phoneNumber'] ?? '',
    );
    _workshopNameController = TextEditingController(
      text: data['workshopName'] ?? '',
    );
    _workshopAddressController = TextEditingController(
      text: data['workshopAddress'] ?? '',
    );
    _workshopPhoneController = TextEditingController(
      text: data['workshopPhone'] ?? '',
    );
    _workshopEmailController = TextEditingController(
      text: data['workshopEmail'] ?? '',
    );
    _workshopOperationHourController = TextEditingController(
      text: data['workshopOperationHour'] ?? '',
    );
    _workshopDetailController = TextEditingController(
      text: data['workshopDetail'] ?? '',
    );
    _profileImageUrl = data['workshopProfilePicture'];
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('New image selected')));
    }
  }

  Future<String?> _uploadProfileImage(String userId) async {
    if (_pickedImage == null) return _profileImageUrl;
    final ref = FirebaseStorage.instance.ref().child(
      'workshop/$userId/profile.jpg',
    );
    await ref.putFile(_pickedImage!);
    return await ref.getDownloadURL();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final imageUrl = await _uploadProfileImage(widget.workshopOwnerId);
      await FirebaseFirestore.instance
          .collection('workshop_owner')
          .doc(widget.workshopOwnerId)
          .update({
            'firstName': _firstNameController.text.trim(),
            'lastName': _lastNameController.text.trim(),
            'email': _emailController.text.trim(),
            'phoneNumber': _phoneNumberController.text.trim(),
            'workshopName': _workshopNameController.text.trim(),
            'workshopAddress': _workshopAddressController.text.trim(),
            'workshopPhone': _workshopPhoneController.text.trim(),
            'workshopEmail': _workshopEmailController.text.trim(),
            'workshopOperationHour':
                _workshopOperationHourController.text.trim(),
            'workshopDetail': _workshopDetailController.text.trim(),
            'workshopProfilePicture': imageUrl,
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
    _workshopNameController.dispose();
    _workshopAddressController.dispose();
    _workshopPhoneController.dispose();
    _workshopEmailController.dispose();
    _workshopOperationHourController.dispose();
    _workshopDetailController.dispose();
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
      appBar: AppBar(title: const Text('Edit Workshop Profile')),
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
                        controller: _workshopNameController,
                        decoration: const InputDecoration(
                          labelText: 'Workshop Name',
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Required'
                                    : null,
                      ),
                      TextFormField(
                        controller: _workshopAddressController,
                        decoration: const InputDecoration(
                          labelText: 'Workshop Address',
                        ),
                        maxLines: 2,
                      ),
                      TextFormField(
                        controller: _workshopPhoneController,
                        decoration: const InputDecoration(
                          labelText: 'Workshop Phone Number',
                        ),
                      ),
                      TextFormField(
                        controller: _workshopEmailController,
                        decoration: const InputDecoration(
                          labelText: 'Workshop Email',
                        ),
                      ),
                      TextFormField(
                        controller: _workshopOperationHourController,
                        decoration: const InputDecoration(
                          labelText: 'Operation Hour',
                        ),
                      ),
                      TextFormField(
                        controller: _workshopDetailController,
                        decoration: const InputDecoration(
                          labelText: 'Descriptions',
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),
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
