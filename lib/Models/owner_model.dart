class OwnerModel {
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String workshopName;
  String workshopAddress;
  String workshopPhone;
  String workshopEmail;
  String workshopOperationHour;
  String workshopDetail;

  OwnerModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.workshopName,
    required this.workshopAddress,
    required this.workshopPhone,
    required this.workshopEmail,
    this.workshopOperationHour = '',
    this.workshopDetail = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'workshopName': workshopName,
      'workshopAddress': workshopAddress,
      'workshopPhone': workshopPhone,
      'workshopEmail': workshopEmail,
      'workshopOperationHour': workshopOperationHour,
      'workshopDetail': workshopDetail,
    };
  }

  factory OwnerModel.fromMap(Map<String, dynamic> map) {
    return OwnerModel(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      workshopName: map['workshopName'] ?? '',
      workshopAddress: map['workshopAddress'] ?? '',
      workshopPhone: map['workshopPhone'] ?? '',
      workshopEmail: map['workshopEmail'] ?? '',
      workshopOperationHour: map['workshopOperationHour'] ?? '',
      workshopDetail: map['workshopDetail'] ?? '',
    );
  }
}
