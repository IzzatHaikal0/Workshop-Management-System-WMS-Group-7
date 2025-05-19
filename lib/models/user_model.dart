class UserModel {
  final String uid;
  final String role;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  UserModel({
    required this.uid,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'user_role': role,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phone,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      role: map['user_role'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone_number'] ?? '',
    );
  }
}
