import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic>? existingProfile;
  const EditProfilePage({super.key, this.existingProfile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;

  late TextEditingController _foremanAddressController;
  late TextEditingController _foremanSkillsController;
  late TextEditingController _foremanExperienceController;

  late TextEditingController _workshopNameController;
  late TextEditingController _workshopAddressController;
  late TextEditingController _workshopPhoneController;
  late TextEditingController _workshopHoursController;
  late TextEditingController _workshopDetailController;

  String? _role;
  String? _existingImageUrl;
  File? _pickedImageFile;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _fetchRole();
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController(
      text: widget.existingProfile?['first_name'] ?? '',
    );
    _lastNameController = TextEditingController(
      text: widget.existingProfile?['last_name'] ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.existingProfile?['phone_number'] ?? '',
    );
    _foremanAddressController = TextEditingController(
      text: widget.existingProfile?['ForemanAddress'] ?? '',
    );
    _foremanSkillsController = TextEditingController(
      text: widget.existingProfile?['ForemanSkills'] ?? '',
    );
    _foremanExperienceController = TextEditingController(
      text: widget.existingProfile?['ForemanWorkExperience'] ?? '',
    );
    _workshopNameController = TextEditingController(
      text: widget.existingProfile?['workshopName'] ?? '',
    );
    _workshopAddressController = TextEditingController(
      text: widget.existingProfile?['workshopAddress'] ?? '',
    );
    _workshopPhoneController = TextEditingController(
      text: widget.existingProfile?['workshopPhone'] ?? '',
    );
    _workshopHoursController = TextEditingController(
      text: widget.existingProfile?['workshopOperationHour'] ?? '',
    );
    _workshopDetailController = TextEditingController(
      text: widget.existingProfile?['workshopDetail'] ?? '',
    );
  }

  Future<void> _fetchRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
    setState(() {
      _role = doc.data()?['role'];
      _existingImageUrl =
          widget.existingProfile?[_role == 'foreman'
              ? 'ForemanProfilePicture'
              : 'workshopProfilePicture'];
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedImageFile = File(picked.path));
    }
  }

  Future<String?> _uploadImage(String uid) async {
    if (_pickedImageFile == null) return _existingImageUrl;
    final ref = FirebaseStorage.instance.ref().child(
      'profile_pictures/$_role/$uid.jpg',
    );
    await ref.putFile(_pickedImageFile!);
    return await ref.getDownloadURL();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      String? imageUrl = await _uploadImage(user.uid);
      Map<String, dynamic> data = {
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'phone_number': _phoneController.text.trim(),
        if (_role == 'foreman') ...{
          'ForemanAddress': _foremanAddressController.text.trim(),
          'ForemanSkills': _foremanSkillsController.text.trim(),
          'ForemanWorkExperience': _foremanExperienceController.text.trim(),
          'ForemanProfilePicture': imageUrl,
        },
        if (_role == 'workshop_owner') ...{
          'workshopName': _workshopNameController.text.trim(),
          'workshopAddress': _workshopAddressController.text.trim(),
          'workshopPhone': _workshopPhoneController.text.trim(),
          'workshopOperationHour': _workshopHoursController.text.trim(),
          'workshopDetail': _workshopDetailController.text.trim(),
          'workshopProfilePicture': imageUrl,
        },
      };

      await FirebaseFirestore.instance
          .collection(_role == 'foreman' ? 'foremen' : 'workshop_owner')
          .doc(user.uid)
          .update(data);

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Update failed: $e')));
    }

    setState(() => _isSaving = false);
  }

  Widget _buildProfileImage() {
    final imageProvider =
        _pickedImageFile != null
            ? FileImage(_pickedImageFile!)
            : (_existingImageUrl != null
                ? NetworkImage(_existingImageUrl!)
                : null);

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: imageProvider as ImageProvider<Object>?,
            backgroundColor: Colors.grey[300],
            child:
                imageProvider == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
          ),
          Positioned(
            bottom: 0,
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.blue),
              onPressed: _pickImage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator:
            required
                ? (val) => val == null || val.isEmpty ? 'Enter $label' : null
                : null,
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _foremanAddressController.dispose();
    _foremanSkillsController.dispose();
    _foremanExperienceController.dispose();
    _workshopNameController.dispose();
    _workshopAddressController.dispose();
    _workshopPhoneController.dispose();
    _workshopHoursController.dispose();
    _workshopDetailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _isSaving || _role == null
                ? const Center(child: CircularProgressIndicator())
                : Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      _buildProfileImage(),
                      _buildSectionTitle('Personal Information'),
                      _buildTextField(
                        _firstNameController,
                        'First Name',
                        required: true,
                      ),
                      _buildTextField(
                        _lastNameController,
                        'Last Name',
                        required: true,
                      ),
                      _buildTextField(
                        _phoneController,
                        'Phone Number',
                        keyboardType: TextInputType.phone,
                        required: true,
                      ),

                      if (_role == 'foreman') ...[
                        _buildSectionTitle('Foreman Details'),
                        _buildTextField(
                          _foremanAddressController,
                          'Address',
                          required: true,
                        ),
                        _buildTextField(_foremanSkillsController, 'Skills'),
                        _buildTextField(
                          _foremanExperienceController,
                          'Work Experience',
                        ),
                      ],

                      if (_role == 'workshop_owner') ...[
                        _buildSectionTitle('Workshop Details'),
                        _buildTextField(
                          _workshopNameController,
                          'Workshop Name',
                        ),
                        _buildTextField(
                          _workshopAddressController,
                          'Workshop Address',
                        ),
                        _buildTextField(
                          _workshopPhoneController,
                          'Workshop Phone Number',
                          keyboardType: TextInputType.phone,
                        ),
                        _buildTextField(
                          _workshopHoursController,
                          'Operation Hours',
                        ),
                        _buildTextField(
                          _workshopDetailController,
                          'Descriptions',
                        ),
                      ],

                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Update'),
                        onPressed: _updateProfile,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
