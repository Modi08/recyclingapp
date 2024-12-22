import 'package:flutter/material.dart';
import '../../pages/profile_screen.dart';
import '../../pages/leaderboard.dart';
import '../../pages/all_users_screen.dart'; // New screen

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // Keeping track of the currently selected index
  int _selectedIndex = 0;

  // List of pages to switch between
  static const List<Widget> _pages = <Widget>[
    ProfileScreen(),
    Leaderboard(),
    AllUsersScreen(), // New "All Users" screen
  ];

  // Function to handle the index change when a button is pressed
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Display the current page
        child: _pages.elementAt(_selectedIndex),
      ),
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
        currentIndex: _selectedIndex, // Highlight the current tab
        selectedItemColor: Colors.green, // Color of the selected item
        onTap: _onItemTapped, // Handle taps
      ),
    );
  }
}
