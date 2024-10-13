import 'package:flutter/material.dart';
import 'leaderboard.dart';
import 'package:recyclingapp/welcome_screen.dart'; // Replace your_app_name with the actual app name
import 'signup_screen.dart'; // Import SignUpScreen
import 'login_screen.dart'; // Import LoginScreen

void main() {
  runApp(const Ecofy()); // Add const here
}

class Ecofy extends StatelessWidget {
  const Ecofy({super.key}); // Add const here

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recycling App',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(), // Add const here
        '/signup': (context) => const SignUpScreen(), // Add const here
        '/login': (context) => const LoginScreen(), // Add const here
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); // Add const here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycling Leaderboard'), // Add const here
      ),
      body: const SingleChildScrollView(
        child: Leaderboard(),
      ),
    );
  }
}
