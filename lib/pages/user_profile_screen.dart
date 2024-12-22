import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  List<String> uploadedPhotos =
      List.generate(9, (index) => "Placeholder $index"); // Example photo list
  int followers = 0; // Initial followers count
  int following = 0; // Initial following count
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

  void followAnotherUser() {
    setState(() {
      following++;
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
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "username",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "This is your bio!",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  int points = 0; // Points given to the user
  bool hasGivenPoints = false; // Tracks if points have been given

  void givePoints() {
    if (!hasGivenPoints) {
      setState(() {
        points++;
        hasGivenPoints = true;
      });
    }
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
          Expanded(
            child: ElevatedButton(
              onPressed: hasGivenPoints
                  ? null
                  : givePoints, // Disable button if points are given
              style: ElevatedButton.styleFrom(
                backgroundColor: hasGivenPoints
                    ? Colors.grey.shade300 // Disabled color
                    : const Color(0xFF37BE81), // Active color
              ),
              child: Text(
                hasGivenPoints ? "Points Given" : "Give 5 Points",
                style: TextStyle(
                  color: hasGivenPoints ? Colors.black : Colors.white,
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
      aspectRatio: 1, // Ensures the grid fits perfectly in a square container
      child: GridView.builder(
        padding: const EdgeInsets.all(2.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Three columns
          crossAxisSpacing: 2, // Equal horizontal spacing
          mainAxisSpacing: 2, // Equal vertical spacing
          childAspectRatio: 1.0, // Ensures all grid items are square
        ),
        itemCount: uploadedPhotos.length,
        physics:
            const NeverScrollableScrollPhysics(), // Prevents internal scrolling
        itemBuilder: (context, index) {
          return Container(
            color: const Color(0xFF37BE81), // Your placeholder color
          );
        },
      ),
    );
  }
}
