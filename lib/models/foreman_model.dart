class ForemanModel {
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String foremanAddress;
  String foremanSkills;
  String foremanWorkExperiences;

  ForemanModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.foremanAddress,
    required this.foremanSkills,
    required this.foremanWorkExperiences,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'foremanAddress': foremanAddress,
      'foremanSkills': foremanSkills,
      'foremanWorkExperiences': foremanWorkExperiences,
    };
  }

  factory ForemanModel.fromMap(Map<String, dynamic> map) {
    return ForemanModel(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      foremanAddress: map['foremanAddress'] ?? '',
      foremanSkills: map['foremanSkills'] ?? '',
      foremanWorkExperiences: map['foremanWorkExperiences'] ?? '',
    );
  }
}
