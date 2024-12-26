import 'package:ecofy/services/general/localstorage.dart';
import 'package:flutter/material.dart';
import 'pages/leaderboard.dart';
import 'package:ecofy/pages/welcome_screen.dart'; // Replace your_app_name with the actual app name
import 'pages/signup_screen.dart'; // Import SignUpScreen
import 'pages/login_screen.dart'; // Import LoginScreen

void main() {
  runApp(const Ecofy());
}

class Ecofy extends StatelessWidget {
  const Ecofy({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService.instance;

    return MaterialApp(
      title: 'Recycling App',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/signup': (context) => SignUpScreen(databaseService: databaseService),
        '/login': (context) => LoginScreen(databaseService: databaseService),
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
      body: const SingleChildScrollView(
        child: Leaderboard(),
      ),
    );
  }
}
