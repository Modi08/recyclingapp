import 'package:flutter/material.dart';
import 'leaderboard.dart';
import 'package:recyclingapp/welcome_screen.dart'; // Replace your_app_name with the actual app name

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
      home: const WelcomeScreen(), // Display the WelcomeScreen first
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
