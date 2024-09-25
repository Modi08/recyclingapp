import 'package:flutter/material.dart';
import 'leaderboard.dart';

void main() {
  runApp(const RecyclingApp());
}

class RecyclingApp extends StatelessWidget {
  const RecyclingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recycling App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
