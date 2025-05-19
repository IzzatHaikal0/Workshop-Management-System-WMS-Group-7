class UserModel {
  final String userRole;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String password;

  UserModel({
    required this.userRole,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  // Optional: Convert UserModel to Map for saving/sending to backend
  Map<String, dynamic> toMap() {
    return {
      'user_role': userRole,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'password': password, // ideally hashed before sending/storing
    };
  }

  // Optional: Create UserModel from Map (e.g., from backend response)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userRole: map['user_role'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      password: map['password'] ?? '',
    );
  }
}
