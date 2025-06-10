import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddProfilePageForeman extends StatefulWidget {
  final String foremanId;
  final Map<String, dynamic> existingProfile;

  const AddProfilePageForeman({
    super.key,
    required this.foremanId,
    required this.existingProfile,
  });

  @override
  State<AddProfilePageForeman> createState() => _AddProfilePageForemanState();
}

class _AddProfilePageForemanState extends State<AddProfilePageForeman> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _foremanAddressController;
  late final TextEditingController _foremanSkillsController;
  late final TextEditingController _foremanWorkExperienceController;

  String? _profileImageUrl;

  File? _pickedImage; // For mobile
  Uint8List? _webImageBytes; // For web

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
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
          _pickedImage = null;
        });
      } else {
        setState(() {
          _pickedImage = File(pickedFile.path);
          _webImageBytes = null;
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('New image selected')));
      }
    }
  }

  Future<String?> _uploadProfileImage(String userId) async {
    if (_pickedImage == null && _webImageBytes == null) return _profileImageUrl;

    final ref = FirebaseStorage.instance.ref().child(
      'foremen/$userId/profile.jpg',
    );

    UploadTask uploadTask;
    if (kIsWeb && _webImageBytes != null) {
      uploadTask = ref.putData(
        _webImageBytes!,
        SettableMetadata(contentType: 'image/jpeg'),
      );
    } else if (_pickedImage != null) {
      uploadTask = ref.putFile(_pickedImage!);
    } else {
      return _profileImageUrl;
    }

    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile has been successfully added')),
      );
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

  // Confirmation dialog method:
  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Confirm Add Profile'),
                content: const Text(
                  'Are you sure you want to add this profile?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Confirm'),
                  ),
                ],
              ),
        ) ??
        false;
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
        kIsWeb
            ? (_webImageBytes != null
                ? MemoryImage(_webImageBytes!)
                : (_profileImageUrl != null
                    ? NetworkImage(_profileImageUrl!)
                    : null))
            : (_pickedImage != null
                ? FileImage(_pickedImage!)
                : (_profileImageUrl != null
                    ? NetworkImage(_profileImageUrl!)
                    : null));

    final bool isNewImageSelected =
        _pickedImage != null || _webImageBytes != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingProfile.isEmpty
              ? 'Add Foreman Profile'
              : 'Add Foreman Profile',
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.grey[300],
                                    backgroundImage: profileImage,
                                    child:
                                        profileImage == null
                                            ? const Icon(
                                              Icons.person,
                                              size: 60,
                                              color: Colors.white70,
                                            )
                                            : null,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: _pickImage,
                                      borderRadius: BorderRadius.circular(30),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(6),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: Text(
                                isNewImageSelected
                                    ? 'New image selected. Will be uploaded when you save.'
                                    : 'Tap pencil icon to add profile picture',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // First Name
                            TextFormField(
                              controller: _firstNameController,
                              decoration: const InputDecoration(
                                labelText: 'First Name',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Required'
                                          : null,
                            ),
                            const SizedBox(height: 16),

                            // Last Name
                            TextFormField(
                              controller: _lastNameController,
                              decoration: const InputDecoration(
                                labelText: 'Last Name',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Required'
                                          : null,
                            ),
                            const SizedBox(height: 16),

                            // Email
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                final emailRegex = RegExp(
                                  r'^[^@]+@[^@]+\.[^@]+',
                                );
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Invalid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Phone Number
                            TextFormField(
                              controller: _phoneNumberController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.phone),
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Required'
                                          : null,
                            ),
                            const SizedBox(height: 16),

                            // Foreman Address
                            TextFormField(
                              controller: _foremanAddressController,
                              decoration: const InputDecoration(
                                labelText: 'Address',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.location_on),
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Required'
                                          : null,
                            ),
                            const SizedBox(height: 16),

                            // Foreman Skills
                            TextFormField(
                              controller: _foremanSkillsController,
                              decoration: const InputDecoration(
                                labelText: 'Skills',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.build),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Foreman Work Experience
                            TextFormField(
                              controller: _foremanWorkExperienceController,
                              decoration: const InputDecoration(
                                labelText: 'Work Experience',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.work),
                              ),
                            ),
                            const SizedBox(height: 32),

                            ElevatedButton.icon(
                              onPressed:
                                  _isLoading
                                      ? null
                                      : () async {
                                        final confirmed =
                                            await _showConfirmationDialog();
                                        if (confirmed) {
                                          await _saveProfile();
                                        }
                                      },
                              icon:
                                  _isLoading
                                      ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : const Icon(Icons.save),
                              label: const Text('Add Profile'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
    );
  }
}
