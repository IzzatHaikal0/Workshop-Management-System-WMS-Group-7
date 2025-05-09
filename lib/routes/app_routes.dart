import 'package:flutter/material.dart';
import '../screens/registration/workshop_owner_register_page.dart';
import '../screens/registration/foreman_register_page.dart';
import '../screens/registration/role_selection_page.dart';

class AppRoutes {
  static final routes = <String, WidgetBuilder>{
    '/': (context) => RoleSelectionPage(),
    '/workshopOwner': (context) => WorkshopOwnerRegisterPage(),
    '/foreman': (context) => ForemanRegisterPage(),
  };
}
