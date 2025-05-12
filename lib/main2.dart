import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workshop_management_system/Screens/ManageInventory/item_create_screen.dart';
import 'package:workshop_management_system/Screens/ManageInventory/item_detail_screen.dart';
import 'package:workshop_management_system/Screens/ManageInventory/item_edit_screen.dart';
import 'package:workshop_management_system/Screens/ManageInventory/item_list_screen.dart';
import 'package:workshop_management_system/Models/ManageInventory/item_model.dart';

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
 //add template for other module routes
class AppRoutes {
  static const String itemList = '/items';
  static const String itemDetail = '/items/detail';
  static const String itemCreate = '/items/create';
  static const String itemEdit = '/items/edit';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workshop Management System App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 41, 11, 240)),
        useMaterial3: true,
      ),
      
      initialRoute: AppRoutes.itemList,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.itemList:
            return MaterialPageRoute(builder: (_) => const ItemListScreen());

          case AppRoutes.itemDetail:
            final item = settings.arguments as Item;
            return MaterialPageRoute(
              builder: (_) => ItemDetailScreen(item: item),
            );

          case AppRoutes.itemCreate:
            return MaterialPageRoute(builder: (_) => ItemCreateScreen());

          case AppRoutes.itemEdit:
            final item = settings.arguments as Item;
            return MaterialPageRoute(
              builder: (_) => ItemEditScreen(item: item),
            );

          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
            );
        }
      },
      home: const MyHomePage(title: 'WMS App'),
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

  final List<Widget> _pages = [
    const Center(child: Text('Workshop Management System App Home Page')),
    const Center(child: Text('Schedule Page')), // Placeholder
    const Center(child: Text('Aina Page')), // Placeholder
    const ItemListScreen(), // Inventory page
  ];

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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.access_alarm), label: 'Aina'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Inventory'),
        ],
      ),
    );
  }
}
