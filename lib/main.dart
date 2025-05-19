import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// ← Add this import
import '../Screens/Registration/manage_registration_barrel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // ← USE this
  );
  runApp(const MyApp());
}

//======================= MODULE ROUTES TEMPLATE =======================//
// ADD YOUR MODULE ROUTE CONSTANTS HERE
class AppRoutes {
  // Main Route
  static const String main = '/';

  // Inventory Module Routes
  // static const String itemList = '/items';
  // static const String itemDetail = '/items/detail';
  // static const String itemCreate = '/items/create';
  // static const String itemEdit = '/items/edit';
  // Request Inventory
  // static const String requestList = '/requests';
  // static const String requestDetail = '/requests/detail';
  // static const String requestCreate = '/requests/create';
  // static const String requestIncoming = '/requests/incoming';

  // Schedule Module Routes
  // static const String scheduleList = '/schedules';
  // static const String scheduleDetail = '/schedules/detail';
  // static const String scheduleCreate = '/schedules/create';
  // static const String scheduleEdit = '/schedules/edit';

  //Registration Routes
  static const String registerType = '/register/type';
  static const String registerForm = '/register/form';
  static const String registrationSuccess = '/register/success';

  // Other module example:
  // static const String yourModuleName = '/your-module-route';
  // static const String yourModuleDetail = '/your-module-route/detail';
  // static const String yourModuleCreate = '/your-module-route/create';
  // static const String yourModuleEdit = '/your-module-route/edit';
}
//====================================================================//

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workshop Management System App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 13, 13, 224),
        ),
        useMaterial3: true,
      ),

      initialRoute: '/', // Start at main/home page
      onGenerateRoute: (settings) {
        //======================= MODULE ROUTES IMPLEMENTATION =======================//
        switch (settings.name) {
          // Main Route- Don't Change
          case AppRoutes.main:
            return MaterialPageRoute(
              builder: (_) => const MyHomePage(title: 'WMS App'),
            );

          // ADD YOUR MODULE ROUTE HERE
          // ====Schedule Module Routes====
          // case AppRoutes.scheduleList:
          //   return MaterialPageRoute(builder: (_) => const ScheduleListScreen());
          //
          // case AppRoutes.scheduleDetail:
          //   final schedule = settings.arguments as Schedule;
          //   return MaterialPageRoute(
          //     builder: (_) => ScheduleDetailScreen(schedule: schedule),
          //   );
          //
          // case AppRoutes.scheduleCreate:
          //   return MaterialPageRoute(builder: (_) => ScheduleCreateScreen());
          //
          // case AppRoutes.scheduleEdit:
          //   final schedule = settings.arguments as Schedule;
          //   return MaterialPageRoute(
          //     builder: (_) => ScheduleEditScreen(schedule: schedule),
          //   );

          // Registration routes
          case AppRoutes.registerType:
            return MaterialPageRoute(builder: (_) => const RegisterType());

          case AppRoutes.registerForm:
            final args = settings.arguments as Map<String, dynamic>;
            final userRole = args['userRole'] as String;
            return MaterialPageRoute(
              builder: (_) => RegisterForm(userRole: userRole),
            );

          case AppRoutes.registrationSuccess:
            return MaterialPageRoute(builder: (_) => RegistrationSuccessPage());

          // ====Inventory Module Routes====
          //case AppRoutes.itemList:
          // return MaterialPageRoute(builder: (_) => const ItemListScreen());

          //case AppRoutes.itemDetail:
          // final item = settings.arguments as Item;
          // return MaterialPageRoute(
          //    builder: (_) => ItemDetailScreen(item: item),
          //  );

          //case AppRoutes.itemCreate:
          //  return MaterialPageRoute(builder: (_) => ItemCreateScreen());

          //case AppRoutes.itemEdit:
          //  final item = settings.arguments as Item;
          //  return MaterialPageRoute(
          //    builder: (_) => ItemEditScreen(item: item),
          //  );

          // ====More Module Here====
          // case AppRoutes.yourModuleName:
          //   return MaterialPageRoute(builder: (_) => const YourModuleListScreen());
          // ... and so on for detail, create, edit

          default:
            return MaterialPageRoute(
              builder:
                  (_) => Scaffold(
                    body: Center(
                      child: Text('No route defined for ${settings.name}'),
                    ),
                  ),
            );
        }
        //==========================================================================//
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  //======================= MODULE PAGES TEMPLATE =======================//
  // ADD YOUR MODULE PAGES HERE
  final List<Widget> _pages = [
    const Center(child: Text('Workshop Management System App Home Page')),
    const Center(child: Text('Schedule Page')), // Schedule page
    const RegisterType(),
    //const ItemListScreen(), // Inventory page
  ];
  //===================================================================//

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 211, 222, 239),
        selectedItemColor: const Color.fromARGB(255, 17, 24, 218),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        //======================= NAVIGATION ITEMS TEMPLATE =======================//
        //ADD YOUR MODULE NAVIGATION ITEMS HERE
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_alarm),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          // cth: BottomNavigationBarItem(icon: Icon(Icons.your_icon), label: 'Your Module'),
        ],
        //======================================================================//
      ),
    );
  }
}
