class ForemanModel {
  final String id; // Document ID or user UID
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;

  // Foreman-specific fields
  final String foremanAddress;
  final String foremanProfilePicture; // URL or local path
  final List<String> foremanSkills;
  final String foremanWorkExperience;

  ForemanModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.foremanAddress,
    required this.foremanProfilePicture,
    required this.foremanSkills,
    required this.foremanWorkExperience,
  });

  // Create from Firestore data + UserModel base data
  factory ForemanModel.fromUserAndMap(
      String id, UserModel user, Map<String, dynamic> data) {
    return ForemanModel(
      id: id,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      phoneNumber: user.phoneNumber,
      foremanAddress: data['foreman_address'] ?? '',
      foremanProfilePicture: data['foreman_profile_picture'] ?? '',
      foremanSkills: List<String>.from(data['foreman_skills'] ?? []),
      foremanWorkExperience: data['foreman_work_experience'] ?? '',
    );
  }

  // Convert to Map for saving/updating Firestore
  Map<String, dynamic> toMap() {
    return {
      'foreman_address': foremanAddress,
      'foreman_profile_picture': foremanProfilePicture,
      'foreman_skills': foremanSkills,
      'foreman_work_experience': foremanWorkExperience,
    };
  }
}
