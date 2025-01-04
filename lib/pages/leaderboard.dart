import 'package:flutter/material.dart';
import 'package:ecofy/services/general/localstorage.dart';

class Leaderboard extends StatefulWidget {
  final double height;
  final double width;
  final DatabaseService database;

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

  void loadLeaderboardData() async {
    try {
      final allUsers = await widget.database.queryAll();
      final mutableUsers = List<Map<String, dynamic>>.from(allUsers);
      mutableUsers.sort((a, b) => (b['countUploadedPhotos'] ?? 0)
          .compareTo(a['countUploadedPhotos'] ?? 0));
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildLeaderboardList()),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: widget.height * 0.4,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            'Leaderboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (topPlayers.length > 1)
                _buildPodiumPlayer(topPlayers[1], 2, Colors.grey, 120),
              if (topPlayers.isNotEmpty)
                _buildPodiumPlayer(topPlayers[0], 1, Colors.amber, 160),
              if (topPlayers.length > 2)
                _buildPodiumPlayer(topPlayers[2], 3, Colors.brown, 100),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumPlayer(
      Map<String, dynamic> player, int rank, Color color, double columnHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: columnHeight,
              width: 60,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            Positioned(
              top: -30,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage:
                    player['profilePic'] != null && player['profilePic'] != ''
                        ? NetworkImage(player['profilePic'])
                        : null,
                child:
                    player['profilePic'] == null || player['profilePic'] == ''
                        ? const Icon(Icons.person, size: 30, color: Colors.grey)
                        : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          player['username'] ?? 'Unknown',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          '${player['countUploadedPhotos'] ?? 0} pts',
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
        Text(
          rank == 1
              ? '1st'
              : rank == 2
                  ? '2nd'
                  : '3rd',
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
        ),
      ],
    );
  }

  Widget _buildLeaderboardList() {
    return ListView.builder(
      itemCount: topPlayers.length - 3,
      itemBuilder: (context, index) {
        final player = topPlayers[index + 3];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    player['profilePic'] != null && player['profilePic'] != ''
                        ? NetworkImage(player['profilePic'])
                        : null,
                child:
                    player['profilePic'] == null || player['profilePic'] == ''
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
              ),
              title: Text(
                player['username'] ?? 'Unknown',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                '${player['countUploadedPhotos'] ?? 0} pts',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
