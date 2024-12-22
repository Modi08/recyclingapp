import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecofy/components/button.dart';
import 'package:ecofy/components/mytextfield.dart';
import 'package:ecofy/services/general/colors.dart';
import 'package:ecofy/services/general/snackbar.dart';
import 'package:ecofy/pages/welcome_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  final confirmPwdController = TextEditingController();
  final usernameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    pwdController.dispose();
    confirmPwdController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void signUp() async {
    String apiUrl = "https://qeh35ldygc.execute-api.eu-central-1.amazonaws.com";

    if (pwdController.text != confirmPwdController.text) {
      if (mounted) {
        showSnackbar(context, "Passwords don't match", true);
      }
      return;
    }

    // Create the request body with default bio
    final requestBody = {
      "email": emailController.text,
      "pwd": pwdController.text,
      "username": usernameController.text,
      "bio": "This is my bio!", // Default bio
      "followers": 0, // Default value for new user
      "following": 0, // Default value for new user
      "uploadedPhotos": [] // Default empty array
    };

    try {
      // Make the HTTP request
      var response = await http.post(
        Uri.parse("$apiUrl/recyclingSignUp"),
        body: jsonEncode(requestBody),
        headers: {
          "Content-Type": "application/json", // Set content type as JSON
        },
      );

      if (mounted) {
        final responseData = jsonDecode(response.body);
        print("Signup response: $responseData"); // Debug the response

        showSnackbar(
          context,
          responseData['msg'],
          response.statusCode == 400,
        );

        if (response.statusCode == 200) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        print("Signup error: $error"); // Debug error
        showSnackbar(context, "An error occurred. Please try again.", true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: appBarColor,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
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
                    "Let's create your account",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 25),
                  MyTextField(
                    controller: usernameController,
                    hintText: "Username",
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: pwdController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: confirmPwdController,
                    hintText: "Confirm Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),
                  CButton(
                    onTap: signUp,
                    text: "Sign Up",
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WelcomeScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Login now',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
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
