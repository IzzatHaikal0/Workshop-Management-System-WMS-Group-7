//import '../models/user_model.dart';
import 'package:workshop_management_system/Models/user_model.dart';
import '../services/save_registration_data.dart';

class RegistrationController {
  final SaveRegistrationData _dataSaver = SaveRegistrationData();

  // Create UserModel from form data
  UserModel createUser({
    required String role,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
  }) {
    // Optionally add password hashing/encryption here

    return UserModel(
      userRole: role,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );
  }

  // Save user data to backend/database
  Future<bool> saveUser(UserModel user) async {
    // Perform validations or preprocessing if needed

    // Save user data
    bool success = await _dataSaver.saveUser(user); // instead of saveUserData

    return success;
  }
}
