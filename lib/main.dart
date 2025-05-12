import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// create barrel file so tk byk nak import ====>> import '../Screens/ManageInventory/manage_inventory_barrel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDz7PsfXEAnJXY7Jc1cAq4ueKnbwZ2X9to",
        authDomain: "workshopmanagementsystem-c80c6.firebaseapp.com",
        projectId: "workshopmanagementsystem-c80c6",
        storageBucket: "workshopmanagementsystem-c80c6.appspot.com", 
        messagingSenderId: "189887749916",
        appId: "1:189887749916:web:d0f9a9d2b4e009472ce4d9",
        measurementId: "G-JJRY2VHEJX",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

//======================= MODULE ROUTES TEMPLATE =======================//
// 1. ADD YOUR MODULE ROUTE CONSTANTS HERE
class AppRoutes {
  // Main Route
  static const String main = '/';
  
  // Inventory Module Routes
  static const String itemList = '/items';
  static const String itemDetail = '/items/detail';
  static const String itemCreate = '/items/create';
  static const String itemEdit = '/items/edit';
  // Request Inventory
  static const String requestList = '/requests';
  static const String requestDetail = '/requests/detail';
  static const String requestCreate = '/requests/create';
  static const String requestIncoming = '/requests/incoming';
  
  // Schedule Module Routes
  // static const String scheduleList = '/schedules';
  // static const String scheduleDetail = '/schedules/detail';
  // static const String scheduleCreate = '/schedules/create';
  // static const String scheduleEdit = '/schedules/edit';
  
  // Aina Module Routes
  // static const String ainaList = '/aina';
  // static const String ainaDetail = '/aina/detail';
  // static const String ainaCreate = '/aina/create';
  // static const String ainaEdit = '/aina/edit';
  
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 13, 13, 224)),
        useMaterial3: true,
      ),
      
      initialRoute: '/', // Start at main/home page
      onGenerateRoute: (settings) {
        //======================= MODULE ROUTES IMPLEMENTATION =======================//
        // ADD YOUR MODULE ROUTE HERE
        switch (settings.name) {
          // Main Route- Don't Change
          case AppRoutes.main:
            return MaterialPageRoute(builder: (_) => const MyHomePage(title: 'WMS App'));
          
            
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
            
          // ====Aina Module Routes====
          // case AppRoutes.ainaList:
          //   return MaterialPageRoute(builder: (_) => const AinaListScreen());
          //
          // case AppRoutes.ainaDetail:
          //   final aina = settings.arguments as Aina;
          //   return MaterialPageRoute(
          //     builder: (_) => AinaDetailScreen(aina: aina),
          //   );
          //
          // case AppRoutes.ainaCreate:
          //   return MaterialPageRoute(builder: (_) => AinaCreateScreen());
          //
          // case AppRoutes.ainaEdit:
          //   final aina = settings.arguments as Aina;
          //   return MaterialPageRoute(
          //     builder: (_) => AinaEditScreen(aina: aina),
          //   );

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
              builder: (_) => Scaffold(
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
    const Center(child: Text('Aina Page')), // Aina page
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
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.access_alarm), label: 'Aina'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Inventory'),
          // cth: BottomNavigationBarItem(icon: Icon(Icons.your_icon), label: 'Your Module'),
        ],
        //======================================================================//
      ),
    );
  }
}