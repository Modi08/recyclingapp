import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecofy/components/button.dart';
import 'package:ecofy/components/mytextfield.dart';
import 'package:ecofy/services/general/colors.dart';
import 'package:ecofy/services/general/snackBar.dart';
import 'package:ecofy/pages/signup_screen.dart';
import 'package:ecofy/services/general/main_navigation.dart'; // Import MainNavigation

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final pwdController = TextEditingController();

  Future<void> login() async {
    String apiUrl = "https://qeh35ldygc.execute-api.eu-central-1.amazonaws.com";
    var paramsApiUrl =
        "$apiUrl/recyclingLoginApp?email=${emailController.text}&pwd=${pwdController.text}";

    try {
      var response = await http.put(Uri.parse(paramsApiUrl));

      if (mounted) {
        var responseData = jsonDecode(response.body);

        // Show message based on response
        showSnackbar(context, responseData['msg'], response.statusCode == 400);

        // If successful, navigate to MainNavigation
        if (response.statusCode == 200) {
          var userData = responseData['user'] ?? {};

          // Ensure necessary fields have default values
          userData = {
            'username': userData['username'] ?? 'Default User',
            'bio': userData['bio'] ?? 'This is my bio!',
            'followers': userData['followers'] ?? 0,
            'following': userData['following'] ?? 0,
            'uploadedPhotos': userData['uploadedPhotos'] ?? [],
          };

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainNavigation(userData: userData),
            ),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        showSnackbar(context, "An error occurred. Please try again.", true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: appBarColor,
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Icon(
                    Icons.recycling_sharp,
                    size: 80,
                    color: logoColor,
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    "Welcome back. You've been missed!",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 25),
                  MyTextField(controller: emailController, hintText: "Email"),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: pwdController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),
                  CButton(onTap: login, text: "Login"),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Register now',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
