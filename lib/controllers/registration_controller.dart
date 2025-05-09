import 'package:logger/logger.dart';
import '../models/user_model.dart';

class RegistrationController {
  final Logger _logger = Logger();

  void registerWorkshopOwner(String name, String email, String password) {
    final WorkshopOwner owner = WorkshopOwner(
      name: name,
      email: email,
      password: password,
    );
    _logger.i('Workshop Owner Registered: ${owner.name}, ${owner.email}');
  }

  void registerForeman(String name, String email, String password) {
    final Foreman foreman = Foreman(name: name, email: email, password: password);
    _logger.i('Foreman Registered: ${foreman.name}, ${foreman.email}');
  }
}
