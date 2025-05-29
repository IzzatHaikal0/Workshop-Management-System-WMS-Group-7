import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Screens/firebase_options.dart';

// Registration and profile barrel imports
import 'Screens/Registration/manage_registration_barrel.dart';
import 'Screens/welcome_screen.dart';
import 'Screens/Profile/manage_profile_barrel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
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
      title: 'Workshop Management System App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 13, 13, 224),
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
                  (_) => AddProfilePageForeman(
                    existingProfile: args['existingProfile'] ?? {},
                    foremanId: args['foremanId'] ?? '',
                  ),
            );

          case AppRoutes.profileEditWorkshopOwner:
            return MaterialPageRoute(
              builder:
                  (_) => AddProfilePageWorkshopOwner(
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String? currentUserRole;
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    fetchUserRole();
  }

  Future<void> fetchUserRole() async {
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
      });
    } else if (workshopOwnerDoc.exists) {
      setState(() {
        currentUserRole = 'workshop_owner';
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get _pages {
    if (currentUserRole == null) {
      return [const Center(child: CircularProgressIndicator())];
    }

    return [
      const Center(child: Text('Workshop Management System App Home Page')),
      const Center(child: Text('Schedule Page')),
      currentUserRole == 'foreman'
          ? ViewProfilePageForeman(foremanId: currentUserId)
          : ViewProfilePageWorkshopOwner(workshopOwnerId: currentUserId),
      const Center(child: Text('Inventory Page')),
    ];
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
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
        ],
      ),
    );
  }
}
