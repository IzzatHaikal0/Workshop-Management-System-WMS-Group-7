class User {
  String name;
  String email;
  String password;

  User({required this.name, required this.email, required this.password});
}

class WorkshopOwner extends User {
  WorkshopOwner({
    required super.name,
    required super.email,
    required super.password,
  });
}

class Foreman extends User {
  Foreman({
    required super.name,
    required super.email,
    required super.password,
  });
}
