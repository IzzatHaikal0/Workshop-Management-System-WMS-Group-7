import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Registration and profile barrel imports
import 'Screens/ManageRegistration/manage_registration_barrel.dart';
import 'Screens/welcome_screen.dart';
import 'Screens/ManageProfile/manage_profile_barrel.dart';
import 'Screens/workshop_homepage.dart'; // <-- NEW IMPORT
import 'Screens/ManageForemanSchedule/manage_foreman_schedule_barrel.dart';
import 'Screens/ManageInventory/inventory_barrel.dart';
import 'Screens/ManageRating/manage_rating_barrel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: "AIzaSyDz7PsfXEAnJXY7Jc1cAq4ueKnbwZ2X9to",
          authDomain: "workshopmanagementsystem-c80c6.firebaseapp.com",
          projectId: "workshopmanagementsystem-c80c6",
          storageBucket: "workshopmanagementsystem-c80c6.firebasestorage.app",
          messagingSenderId: "189887749916",
          appId: "1:189887749916:web:d0f9a9d2b4e009472ce4d9",
          measurementId: "G-JJRY2VHEJX",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    runApp(const MyApp());
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
    return;
  }
}

class AppRoutes {
  static const String welcome = '/welcome';
  static const String main = '/MyApp';
  static const String registerType = '/register/type';
  static const String registerForm = '/register/form';
  static const String registrationSuccess = '/register/success';
  static const String login = '/login';

  static const String profileViewForeman = '/profile/view/foreman';
  static const String profileViewWorkshopOwner = '/profile/view/workshop_owner';
  static const String profileAddForeman = '/profile/add/foreman';
  static const String profileAddWorkshopOwner = '/profile/add/workshop_owner';
  static const String profileEditForeman = '/profile/edit/foreman';
  static const String profileEditWorkshopOwner = '/profile/edit/workshop_owner';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomen.IO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 23, 80, 202),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        switch (settings.name) {
          case AppRoutes.welcome:
            return MaterialPageRoute(builder: (_) => const WelcomeScreen());

          case AppRoutes.main:
            return MaterialPageRoute(
              builder: (_) => const MyHomePage(title: 'WMS App'),
            );

          case AppRoutes.registerType:
            return MaterialPageRoute(builder: (_) => const RegisterType());

          case AppRoutes.registerForm:
            final userRole = args['userRole'] as String? ?? '';
            return MaterialPageRoute(
              builder: (_) => RegisterForm(userRole: userRole),
            );

          case AppRoutes.registrationSuccess:
            return MaterialPageRoute(
              builder: (_) => const RegistrationSuccessPage(),
            );

          case AppRoutes.login:
            return MaterialPageRoute(builder: (_) => const LoginScreen());

          case AppRoutes.profileViewForeman:
            return MaterialPageRoute(
              builder:
                  (_) => ViewProfilePageForeman(
                    foremanId: args['foremanId'] ?? '',
                  ),
            );

          case AppRoutes.profileViewWorkshopOwner:
            return MaterialPageRoute(
              builder:
                  (_) => ViewProfilePageWorkshopOwner(
                    workshopOwnerId: args['workshopOwnerId'] ?? '',
                  ),
            );

          case AppRoutes.profileEditForeman:
            return MaterialPageRoute(
              builder:
                  (_) => EditProfilePageForeman(
                    existingProfile: args['existingProfile'] ?? {},
                    foremanId: args['foremanId'] ?? '',
                  ),
            );

          case AppRoutes.profileEditWorkshopOwner:
            return MaterialPageRoute(
              builder:
                  (_) => EditProfilePageWorkshopOwner(
                    existingProfile: args['existingProfile'] ?? {},
                    workshopOwnerId: args['workshopOwnerId'] ?? '',
                  ),
            );
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
      },
    );
  }
}

// AuthGate
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const MyHomePage(title: 'WMS App');
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }
}

// MyHomePage
// MyHomePage
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  //final Icon icon;
  //final Icon icon;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String? currentUserRole;
  String userName = '';
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    fetchUserRoleAndName();
  }

  Future<void> fetchUserRoleAndName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final foremanDoc =
        await FirebaseFirestore.instance.collection('foremen').doc(uid).get();
    final workshopOwnerDoc =
        await FirebaseFirestore.instance
            .collection('workshop_owner')
            .doc(uid)
            .get();

    if (foremanDoc.exists) {
      setState(() {
        currentUserRole = 'foreman';
        userName = foremanDoc.data()?['firstName'] ?? 'Foreman';
      });
    } else if (workshopOwnerDoc.exists) {
      setState(() {
        currentUserRole = 'workshop_owner';
        userName = workshopOwnerDoc.data()?['firstName'] ?? 'Workshop Owner';
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget roleIcon(String? role) {
    switch (role) {
      case 'foreman':
        return const Icon(Icons.engineering, color: Colors.white);
      case 'workshop_owner':
        return const Icon(Icons.business, color: Colors.white);
      default:
        return const Icon(Icons.person, color: Colors.white);
    }
  }

  // Pages
  List<Widget> get _pages {
    if (currentUserRole == null) {
      return [const Center(child: CircularProgressIndicator())];
    }
    List<Widget> pages = [
      const WorkshopHomePage(),
      currentUserRole == 'foreman'
          ? SelectSchedulePage(foremenId: currentUserId)
          : ListSchedulePage(workshopOwnerId: currentUserId),
      currentUserRole == 'foreman'
          ? ViewProfilePageForeman(foremanId: currentUserId)
          : ViewProfilePageWorkshopOwner(workshopOwnerId: currentUserId),
    ];

    /// Manage Inventory only accessible for workshop owner
    if (currentUserRole != null && currentUserRole == 'workshop_owner') {
      pages.add(ListInventoryPage(currentUserRole: currentUserRole!));
    }
    return pages;
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout Confirmation'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Logout'),
              ),
            ],
          ),
    );
    if (shouldLogout == true) {
      await FirebaseAuth.instance.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Hi, $userName'),
            const SizedBox(width: 8),
            roleIcon(currentUserRole),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.rate_review),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          currentUserRole == 'workshop_owner'
                              ? RatingPage()
                              : ForemanPage(foremanId: currentUserId),
                ),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _confirmLogout,
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 211, 222, 239),
        selectedItemColor: const Color.fromARGB(255, 17, 24, 218),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedule',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),

          /// MANAGE INVENTORY ONLY WORKSHOP OWNER CAN ACCESS
          if (currentUserRole == 'workshop_owner')
            const BottomNavigationBarItem(
              icon: Icon(Icons.inventory),
              label: 'Inventory',
            ),
        ],
      ),
    );
  }
}
