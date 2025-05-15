import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workshop_management_system/Screens/ManageForemanSchedule/ListSchedulePage.dart';
import 'package:workshop_management_system/Screens/ManageForemanSchedule/SelectSchedulePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: "AIzaSyDz7PsfXEAnJXY7Jc1cAq4ueKnbwZ2X9to",
              authDomain: "workshopmanagementsystem-c80c6.firebaseapp.com",
              projectId: "workshopmanagementsystem-c80c6",
              storageBucket:
                  "workshopmanagementsystem-c80c6.firebasestorage.app",
              messagingSenderId: "189887749916",
              appId: "1:189887749916:web:d0f9a9d2b4e009472ce4d9",
              measurementId: "G-JJRY2VHEJX"));
    } else {
      await Firebase.initializeApp();
    }
    runApp(const MyApp());
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
    return;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workshop Management Sytstem App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Workshop Management System App Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  //navigation pages
  final List<Widget> _pages = [
    const Center(child: Text('Home Page')), // Home page
    ListSchedulePage(), // Navigate to SchedulePage
    SelectSchedulePage(), // Placeholder for Page 3
    const Center(child: Text('Page 4')), // Placeholder for Page 4
    const Center(child: Text('Page 5')), // Placeholder for Page 5
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
      body: _pages[_selectedIndex], // Display the selected page

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey, // Unselected item color
        currentIndex:
            _selectedIndex, // Set the current tab based on _selectedIndex
        onTap: _onItemTapped, // Handle tab selection
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_alarm),
            label: 'aina',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'aimar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'resya',
          ),
        ],
      ),
    );
  }
}
