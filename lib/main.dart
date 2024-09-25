import 'package:flutter/material.dart';

void main() {
  runApp(RecyclingApp());
}

class RecyclingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recycling App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to the Recycling App'),
      ),
      body: Center(
        child: Text('Start tracking your eco-friendly actions!'),
      ),
    );
  }
}
