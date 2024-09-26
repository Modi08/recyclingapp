import 'package:flutter/material.dart';
import 'leaderboard.dart';
import 'package:recyclingapp/welcome_screen.dart'; // Replace your_app_name with the actual app name
import 'signup_screen.dart'; // Import SignUpScreen
import 'login_screen.dart'; // Import LoginScreen

void main() {
  runApp(const RecyclingApp());
}

class RecyclingApp extends StatelessWidget {
  const RecyclingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recycling App',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycling Leaderboard'),
      ),
      body: SingleChildScrollView(
        child: Leaderboard(),
      ),
    );
  }
}
