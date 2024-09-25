import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Image or illustration section occupying a bit less than 75% of the screen
            Expanded(
              flex: 3, // Reduced this slightly so it takes less than 75%
              child: Container(
                width: double.infinity, // Ensures the image fills the width
                child: Image.asset(
                  'assets/recycle.png', // Make sure the path is correct
                  fit: BoxFit.cover, // Ensures the image fills the container
                ),
              ),
            ),
            // Text and buttons section occupying the remaining space
            Expanded(
              flex:
                  2, // Increased this flex to 2, so it occupies a bit more space
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Added padding
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Text section
                    Column(
                      children: [
                        Text(
                          'Recycle',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text(
                            'Help make our planet greener by recycling and competing with others!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Buttons section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0), // Adjusted padding for buttons
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Add navigation to sign-up page
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green, // Background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                              height: 10), // Reduced spacing between buttons
                          OutlinedButton(
                            onPressed: () {
                              // Add navigation to log-in page
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Colors.green, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
