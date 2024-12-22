import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  List<dynamic> users = []; // User data from API
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    String apiUrl =
        "https://your-api-endpoint.com/users"; // Update with your API endpoint

    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          users = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        // Handle error response
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Users"),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(users[index]['name'] ?? "Unknown"),
                  subtitle: Text(users[index]['email'] ?? "No email"),
                  onTap: () {
                    // Navigate to user's profile
                  },
                );
              },
            ),
    );
  }
}
