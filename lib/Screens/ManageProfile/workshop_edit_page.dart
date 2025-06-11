import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
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
  Uint8List? _webImageBytes;

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
      'workshop_owners/$userId/profile.jpg',
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile has been successfully updated')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmAndSaveProfile() async {
    final shouldSave = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Update'),
            content: const Text('Are you sure you want to save changes?'),
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
    );

    if (shouldSave == true) {
      await _saveProfile();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Edit Workshop Owner Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                                    backgroundColor: Colors.blue.shade100,
                                    backgroundImage: profileImage,
                                    child:
                                        profileImage == null
                                            ? const Icon(
                                              Icons.person,
                                              size: 60,
                                              color: Colors.blue,
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
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.blue,
                                            width: 2,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(6),
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
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
                                    : 'Tap pencil icon to change profile picture',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // The rest of the TextFormFields remain unchanged
                            // (Omitted here for brevity, but they are exactly as in your original code)
                            // Include all TextFormFields as before
                            // ...
                            const SizedBox(height: 30),
                            ElevatedButton.icon(
                              onPressed:
                                  _isLoading ? null : _confirmAndSaveProfile,
                              icon: const Icon(Icons.save),
                              label: const Text('Save Changes'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
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
