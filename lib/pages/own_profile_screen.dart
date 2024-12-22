import 'package:flutter/material.dart';

class OwnProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const OwnProfileScreen(
      {super.key, required this.userData}); // Update constructor

  @override
  State<OwnProfileScreen> createState() => _OwnProfileScreenState();
}

class _OwnProfileScreenState extends State<OwnProfileScreen> {
  late List<String> uploadedPhotos;
  late int followers;
  late int following;

  @override
  void initState() {
    super.initState();
    uploadedPhotos = widget.userData['uploadedPhotos']?.cast<String>() ?? [];
    followers = widget.userData['followers'] ?? 0;
    following = widget.userData['following'] ?? 0;
  }

  bool isFollowing = false;

  void followUser() {
    setState(() {
      if (!isFollowing) {
        followers++;
      } else {
        followers--;
      }
      isFollowing = !isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                _buildCountColumn("Posts", uploadedPhotos.length.toString()),
                _buildCountColumn("Followers", followers.toString()),
                _buildCountColumn("Following", following.toString()),
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
            widget.userData['name'] ?? "Unknown User",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            widget.userData['bio'] ?? "No bio available",
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
              onPressed: followUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: isFollowing
                    ? Colors.grey.shade300
                    : const Color(0xFF37BE81),
              ),
              child: Text(
                isFollowing ? "Following" : "Follow",
                style: TextStyle(
                  color: isFollowing ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
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
        itemCount: uploadedPhotos.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            color: const Color(0xFF37BE81),
          );
        },
      ),
    );
  }
}
