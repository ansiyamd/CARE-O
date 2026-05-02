import 'package:careo_new/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'screens/video_call_screen.dart';
// Import Screens
import 'screens/home_screen.dart';
import 'screens/entertainment_screen.dart';
import 'screens/health_wellness_screen.dart';
import 'screens/devotional_screen.dart';
import 'screens/fitness_screen.dart';
import 'screens/guardian.dart';
import 'screens/social_connections_screen.dart';
import 'screens/games_screen.dart';
import 'screens/music_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/meditation_screen.dart';
import 'screens/medication_reminders_screen.dart';
import 'MedicationIntakeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("\ud83d\udd25 Firebase Initialized Successfully");

  try {
    ApiService apiService = ApiService();
    String? token = await apiService.fetchAgoraToken("careo");
    print("Agora Token: $token");
  } catch (e) {
    print("❌ Error fetching Agora token: $e");
  }

  runApp(CareoApp());
}

class CareoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareO',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 244, 184, 5),
          titleTextStyle: TextStyle(
            color: Color.fromARGB(255, 5, 5, 5),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      home: AuthWrapper(), // Handles user authentication status
      routes: {
        '/video_call': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is String && args.isNotEmpty) {
            return VideoCallScreen(channelName: args);
          }
          return const Scaffold(
            body: Center(child: Text("Invalid channel name")),
          );
        },
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(),
        '/health_wellness': (context) => HealthWellnessScreen(),
        '/entertainment': (context) => EntertainmentScreen(),
        '/devotional': (context) => DevotionalScreen(),
        '/fitness': (context) => FitnessScreen(),
        '/guardian': (context) => GuardianScreen(),
        '/social_connections': (context) => SocialConnectionsScreen(),
        '/games': (context) => GamesScreen(),
        '/music': (context) => MusicScreen(),
        '/meditation': (context) => MeditationScreen(),
        '/medication_reminders': (context) => MedicationRemindersScreen(),
        '/medication_intake': (context) => MedicationIntakeScreen(),
      },
    );
  }
}

// Handles Auth Redirects
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return HomeScreen(); // User is logged in
        } else {
          return LoginScreen(); // User is not logged in
        }
      },
    );
  }
}
