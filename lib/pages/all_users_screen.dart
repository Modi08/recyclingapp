// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:ecofy/services/general/socket.dart'; // Import your socket helper

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  bool isLoading = true;
  late WebSocketChannel socket;

  void _refreshUsers(List<Map<String, dynamic>> users) {
    setState(() {
      allUsers = users;
      filteredUsers = List.from(allUsers);
      isLoading = false;
    });
  }

  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredUsers = List.from(allUsers);
      } else {
        filteredUsers = allUsers
            .where((user) =>
                user["username"]?.toLowerCase().contains(query.toLowerCase()) ??
                false)
            .toList();
      }
    });
  }

  @override
  void dispose() {
    // Close the WebSocket connection when the widget is disposed
    socket.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF37BE81),
        title: const Text("All Users", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: _filterUsers,
                    decoration: const InputDecoration(
                      hintText: "Search users...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                // User List
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return ListTile(
                        leading: const ClipOval(
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                        title: Text(user["username"] ?? "Unknown User"),
                        onTap: () {
                          debugPrint("Tapped on ${user['username']}");
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
