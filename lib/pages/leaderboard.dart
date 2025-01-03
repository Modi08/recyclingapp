import 'package:flutter/material.dart';
import 'package:ecofy/services/general/localstorage.dart';

class Leaderboard extends StatefulWidget {
  final double height;
  final double width;
  final DatabaseService database; // Add database service reference

  const Leaderboard({
    super.key,
    required this.height,
    required this.width,
    required this.database,
  });

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<Map<String, dynamic>> topPlayers = [];
  bool isLoading = true;

  // Fetch top players based on uploaded photos (points)
  void loadLeaderboardData() async {
    try {
      final allUsers = await widget.database.queryAll();
      // Create a mutable copy of the list
      final mutableUsers = List<Map<String, dynamic>>.from(allUsers);
      // Sort users by the number of uploaded photos (points) in descending order
      mutableUsers.sort((a, b) => (b['countUploadedPhotos'] ?? 0)
          .compareTo(a['countUploadedPhotos'] ?? 0));
      // Take the top 10 users
      setState(() {
        topPlayers = mutableUsers.take(10).toList();
        isLoading = false;
      });
    } catch (error) {
      print("Error loading leaderboard data: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadLeaderboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF37BE81),
        title: const Text("Leaderboard", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                // Add this
                child: Column(
                  children: [
                    const Text(
                      'LEADERBOARD',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    SizedBox(height: widget.height * 0.02),
                    topPlayers.length >= 3 ? _buildTopThree() : Container(),
                    SizedBox(height: widget.height * 0.02),
                    _buildRestOfLeaderboard(),
                  ],
                ),
              ),
            ),
    );
  }

  // Build the top 3 players
  Widget _buildTopThree() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (topPlayers.length > 1) _buildTopPlayer(topPlayers[1], 2),
        if (topPlayers.isNotEmpty)
          _buildTopPlayer(topPlayers[0], 1, isFirst: true),
        if (topPlayers.length > 2) _buildTopPlayer(topPlayers[2], 3),
      ],
    );
  }

  // Build a top player card
  Widget _buildTopPlayer(Map<String, dynamic> player, int rank,
      {bool isFirst = false}) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amberAccent,
          ),
          padding: const EdgeInsets.all(16),
          child: Icon(
            Icons.person,
            size: isFirst ? 60 : 40,
            color: Colors.white,
          ),
        ),
        SizedBox(height: widget.height * 0.005),
        Text(
          player['username'] ?? 'Unknown',
          style: TextStyle(
            fontSize: isFirst ? 18 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          (player['countUploadedPhotos'] ?? 0).toString(), // Display points
          style: TextStyle(
            fontSize: isFirst ? 24 : 18,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        SizedBox(height: widget.height * 0.005),
        CircleAvatar(
          radius: widget.width * 0.02,
          backgroundColor: Colors.yellow,
          child: Text(rank.toString(),
              style: const TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  // Build the rest of the leaderboard
  Widget _buildRestOfLeaderboard() {
    if (topPlayers.length <= 3) {
      return const SizedBox(); // Return an empty widget if there are no additional players
    }

    return Column(
      children: topPlayers.sublist(3).asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> player = entry.value;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amberAccent,
              child: Text((index + 4).toString(),
                  style: const TextStyle(color: Colors.black)),
            ),
            title: Text(player['username'] ?? 'Unknown'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                (player['countUploadedPhotos'] ?? 0)
                    .toString(), // Display points
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
