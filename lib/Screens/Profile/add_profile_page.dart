import 'dart:io' show File;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddProfilePage extends StatefulWidget {
  final Map<String, dynamic>? existingProfile;
  final String? role; // Optional: pass role from outside if known

  const AddProfilePage({super.key, this.existingProfile, this.role});

  @override
  State<AddProfilePage> createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
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

  XFile? _pickedImageFile;
  Uint8List? _pickedImageBytes; // For Web preview

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    if (widget.role != null) {
      _role = widget.role;
      _loadExistingImageUrl();
    } else {
      _fetchRole();
    }
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

  void _loadExistingImageUrl() {
    setState(() {
      _existingImageUrl =
          widget.existingProfile?[_role == 'foreman'
              ? 'ForemanProfilePicture'
              : 'workshopProfilePicture'];
    });
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
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _pickedImageFile = picked;
          _pickedImageBytes = bytes;
        });
      } else {
        setState(() {
          _pickedImageFile = picked;
          _pickedImageBytes = null;
        });
      }
    }
  }

  Future<String?> _uploadImage(String uid) async {
    if (_pickedImageFile == null) return _existingImageUrl;

    final ref = FirebaseStorage.instance.ref().child(
      'profile_pictures/$_role/$uid.jpg',
    );

    if (kIsWeb) {
      await ref.putData(_pickedImageBytes!);
    } else {
      await ref.putFile(File(_pickedImageFile!.path));
    }

    return await ref.getDownloadURL();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No user logged in')));
      return;
    }

    try {
      String? imageUrl = await _uploadImage(user.uid);

      final data = {
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
          .set(data, SetOptions(merge: true));

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Update failed: $e')));
      }
    }

    setState(() => _isSaving = false);
  }

  Widget _buildProfileImage() {
    ImageProvider<Object>? imageProvider;

    if (_pickedImageFile != null) {
      if (kIsWeb && _pickedImageBytes != null) {
        imageProvider = MemoryImage(_pickedImageBytes!);
      } else {
        imageProvider = FileImage(File(_pickedImageFile!.path));
      }
    } else if (_existingImageUrl != null) {
      imageProvider = NetworkImage(_existingImageUrl!);
    }

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: imageProvider,
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
                ? (val) {
                  if (val == null || val.isEmpty) {
                    return 'Enter $label';
                  }
                  return null;
                }
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
      appBar: AppBar(title: const Text('Add / Edit Profile')),
      body:
          _role == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileImage(),
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
                          required: true,
                        ),
                        _buildTextField(
                          _workshopAddressController,
                          'Address',
                          required: true,
                        ),
                        _buildTextField(
                          _workshopPhoneController,
                          'Phone Number',
                          keyboardType: TextInputType.phone,
                          required: true,
                        ),
                        _buildTextField(
                          _workshopHoursController,
                          'Operation Hours',
                        ),
                        _buildTextField(
                          _workshopDetailController,
                          'Workshop Detail',
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _updateProfile,
                          child:
                              _isSaving
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
