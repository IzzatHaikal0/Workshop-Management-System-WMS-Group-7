import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:workshop_management_system/Screens/ManageProfile/foreman_view_page.dart';

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
  File? _pickedImage;
  Uint8List? _webImageBytes;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadForemanData();
  }

  Future<void> _loadForemanData() async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('foremen')
              .doc(widget.foremanId)
              .get();
      final data = doc.data();

      if (data == null) throw Exception('Foreman profile not found');

      setState(() {
        _firstNameController = TextEditingController(
          text: data['firstName'] ?? '',
        );
        _lastNameController = TextEditingController(
          text: data['lastName'] ?? '',
        );
        _emailController = TextEditingController(text: data['email'] ?? '');
        _phoneNumberController = TextEditingController(
          text: data['phoneNumber'] ?? '',
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
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading profile: $e')));
        setState(() => _isLoading = false);
      }
    }
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

    final confirmed = await _showConfirmationDialog();
    if (!confirmed) return;

    setState(() => _isLoading = true);

    try {
      final imageUrl = await _uploadProfileImage(widget.foremanId);

      await FirebaseFirestore.instance
          .collection('foremen')
          .doc(widget.foremanId)
          .set({
            'firstName': _firstNameController.text.trim(),
            'lastName': _lastNameController.text.trim(),
            'email': _emailController.text.trim(),
            'phoneNumber': _phoneNumberController.text.trim(),
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
        automaticallyImplyLeading: false,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                color: const Color(0xFF4169E1),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ViewProfilePageForeman(
                            foremanId: widget.foremanId,
                          ),
                    ),
                  );
                },
              ),
            ),
            const Center(
              child: Text(
                'Add Foreman Profile',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
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
                                    right: 4,
                                    child: InkWell(
                                      onTap: _pickImage,
                                      borderRadius: BorderRadius.circular(30),
                                      child: Tooltip(
                                        message: 'Edit Profile Picture',
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(6),
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 18,
                                          ),
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
                            _buildTextField(
                              _firstNameController,
                              'First Name',
                              Icons.person,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              _lastNameController,
                              'Last Name',
                              Icons.person_outline,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              _emailController,
                              'Email',
                              Icons.email,
                              isEmail: true,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              _phoneNumberController,
                              'Phone Number',
                              Icons.phone,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              _foremanAddressController,
                              'Address',
                              Icons.home,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              _foremanSkillsController,
                              'Skills',
                              Icons.build,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              _foremanWorkExperienceController,
                              'Work Experience',
                              Icons.work,
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton.icon(
                              onPressed: _saveProfile,
                              icon: const Icon(Icons.save),
                              label: const Text('Save Profile'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
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

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isEmail = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Required';
        if (isEmail) {
          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
          if (!emailRegex.hasMatch(value)) return 'Invalid email';
        }
        return null;
      },
    );
  }
}
