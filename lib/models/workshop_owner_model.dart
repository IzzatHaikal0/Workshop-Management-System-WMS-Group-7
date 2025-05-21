class WorkshopOwnerModel {
  final String id; // Document ID or user UID
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;

  // Workshop-specific fields
  final String workshopName;
  final String workshopAddress;
  final String workshopPhone;
  final String workshopEmail;
  final String workshopProfilePicture; // URL or local path
  final String workshopOperationHour;
  final String workshopDetail;

  WorkshopOwnerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.workshopName,
    required this.workshopAddress,
    required this.workshopPhone,
    required this.workshopEmail,
    required this.workshopProfilePicture,
    required this.workshopOperationHour,
    required this.workshopDetail,
  });

  // Create from Firestore data + UserModel base data
  factory WorkshopOwnerModel.fromUserAndMap(
      String id, UserModel user, Map<String, dynamic> data) {
    return WorkshopOwnerModel(
      id: id,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      phoneNumber: user.phoneNumber,
      workshopName: data['workshop_name'] ?? '',
      workshopAddress: data['workshop_address'] ?? '',
      workshopPhone: data['workshop_phone'] ?? '',
      workshopEmail: data['workshop_email'] ?? '',
      workshopProfilePicture: data['workshop_profile_picture'] ?? '',
      workshopOperationHour: data['workshop_operation_hour'] ?? '',
      workshopDetail: data['workshop_detail'] ?? '',
    );
  }

  // Convert to Map for saving/updating Firestore
  Map<String, dynamic> toMap() {
    return {
      'workshop_name': workshopName,
      'workshop_address': workshopAddress,
      'workshop_phone': workshopPhone,
      'workshop_email': workshopEmail,
      'workshop_profile_picture': workshopProfilePicture,
      'workshop_operation_hour': workshopOperationHour,
      'workshop_detail': workshopDetail,
    };
  }
}
