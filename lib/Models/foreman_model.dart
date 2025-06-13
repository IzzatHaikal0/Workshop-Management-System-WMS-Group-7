class ForemanModel {
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String foremanAddress;
  String foremanSkills;
  String foremanExperiences;

  ForemanModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.foremanAddress,
    required this.foremanSkills,
    required this.foremanExperiences,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'foremanAddress': foremanAddress,
      'foremanSkills': foremanSkills,
      'foremanExperiences': foremanExperiences,
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
      foremanExperiences: map['foremanWorkExperiences'] ?? '',
    );
  }
}
