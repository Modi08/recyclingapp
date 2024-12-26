import 'package:ecofy/services/general/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:ecofy/pages/settings_screen.dart';

class OwnProfileScreen extends StatefulWidget {
  final DatabaseService databaseService;

  const OwnProfileScreen({super.key, required this.databaseService});

  @override
  State<OwnProfileScreen> createState() => _OwnProfileScreenState();
}

class _OwnProfileScreenState extends State<OwnProfileScreen> {
  Map<String, dynamic> userData = {};
  bool isLoading = true;
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (widget.databaseService != null) {
      setState(() {
        //change bellow
        //userData = widget.databaseService;
        _addDefaultPhotos();
        isLoading = false;
      });
    } else {
      userData = await fetchUserData();
      setState(() {
        _addDefaultPhotos();
        isLoading = false;
      });
    }
  }

  void _addDefaultPhotos() {
    // Only add placeholders for display, but they won't count as uploaded photos
    userData['uploadedPhotos'] ??= [];
    if (userData['uploadedPhotos'].isEmpty) {
      userData['placeholders'] = List.generate(9, (index) => "");
    } else {
      userData['placeholders'] = [];
    }
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    await Future.delayed(const Duration(seconds: 2));
    return {
      'username': 'JAC',
      'bio': 'This is a dynamically fetched bio.',
      'uploadedPhotos': [],
      'followers': 10,
      'following': 5,
    };
  }

  void followUser() {
    setState(() {
      if (!isFollowing) {
        userData['followers'] = (userData['followers'] ?? 0) + 1;
      } else {
        userData['followers'] = (userData['followers'] ?? 0) - 1;
      }
      isFollowing = !isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildUserInfo(),
                _buildButtons(),
                const Divider(),
                _buildTabBar(),
                _buildTabView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: Container(
              width: 80,
              height: 80,
              color: Colors.grey.shade300,
              child: const Icon(Icons.person, size: 40, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCountColumn("Posts",
                    (userData['uploadedPhotos']?.length ?? 0).toString()),
                _buildCountColumn(
                    "Followers", (userData['followers'] ?? 0).toString()),
                _buildCountColumn(
                    "Following", (userData['following'] ?? 0).toString()),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCountColumn(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userData['username'] ?? "Unknown User",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            userData['bio'] ?? "No bio available",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the settings screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF37BE81),
              ),
              child: const Text(
                "Edit Your Profile",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              // Navigate to the settings screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.settings, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return const TabBar(
      unselectedLabelColor: Colors.grey,
      labelColor: Colors.black,
      indicatorColor: Colors.black,
      tabs: [
        Icon(Icons.grid_on),
        Icon(Icons.video_collection),
        Icon(Icons.person),
      ],
    );
  }

  Widget _buildTabView() {
    return SizedBox(
      height: 400,
      child: TabBarView(
        children: [
          _buildGridView(),
          const Center(child: Text("Videos")),
          const Center(child: Text("Tagged")),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    final photos = userData['uploadedPhotos']!;
    final placeholders = userData['placeholders']!;

    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        padding: const EdgeInsets.all(2.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 1.0,
        ),
        itemCount: photos.length + placeholders.length,
        itemBuilder: (context, index) {
          final isPlaceholder = index >= photos.length;
          return Container(
            color: const Color(0xFF37BE81),
            alignment: Alignment.center,
            child: Text(
              isPlaceholder
                  ? placeholders[index - photos.length]
                  : photos[index],
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
