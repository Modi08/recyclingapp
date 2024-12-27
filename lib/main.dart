import 'package:ecofy/services/general/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/leaderboard.dart';
import 'package:ecofy/pages/welcome_screen.dart'; // Replace your_app_name with the actual app name
import 'pages/signup_screen.dart'; // Import SignUpScreen
import 'pages/login_screen.dart'; // Import LoginScreen

void main() {
  runApp(const Ecofy());
}

class Ecofy extends StatefulWidget {
  const Ecofy({super.key});

  @override
  State<Ecofy> createState() => _EcofyState();
}

class _EcofyState extends State<Ecofy> {
  final DatabaseService database = DatabaseService.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Recycling App',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/signup': (context) => SignUpScreen(database: database),
        '/login': (context) => LoginScreen(database: database),
      },
    );
  }
}