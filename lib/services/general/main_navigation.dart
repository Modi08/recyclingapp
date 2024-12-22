import 'package:flutter/material.dart';
import '../../pages/own_profile_screen.dart';
import '../../pages/leaderboard.dart';
import '../../pages/all_users_screen.dart'; // New screen

class MainNavigation extends StatefulWidget {
  final Map<String, dynamic> userData; // Accept user data

  const MainNavigation(
      {super.key, required this.userData}); // Add required parameter

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return OwnProfileScreen(userData: widget.userData); // Pass userData
      case 1:
        return const Leaderboard();
      case 2:
        return const AllUsersScreen();
      default:
        return const Center(child: Text('Page not found'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'All Users',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}
