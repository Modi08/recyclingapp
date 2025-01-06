// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:ecofy/pages/login_screen.dart';
import 'package:ecofy/services/general/localstorage.dart';
import 'package:ecofy/services/general/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:ecofy/components/button.dart';
import 'package:ecofy/components/mytextfield.dart';
import 'package:ecofy/services/general/colors.dart';
import 'package:ecofy/services/general/snackbar.dart';

class SignUpScreen extends StatefulWidget {
  final DatabaseService database;
  final double height;
  final double width;
  const SignUpScreen(
      {super.key,
      required this.database,
      required this.height,
      required this.width});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  final confirmPwdController = TextEditingController();
  final usernameController = TextEditingController();
  late String? apiUrl;

  @override
  void dispose() {
    emailController.dispose();
    pwdController.dispose();
    confirmPwdController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void signUp() async {
    await dotenv.load();

    apiUrl = dotenv.env["httpURL"];

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
      "username": usernameController.text
      /*
      "bio": "This is my bio!", // Default bio
      "followers": 0, // Default value for new user
      "following": 0, // Default value for new user
      "uploadedPhotos": [] // Default empty array*/

      // Added on server side
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
        //print("Signup response: ${responseData["user"]}"); // Debug the response

        showSnackbar(
          context,
          responseData['msg'],
          response.statusCode == 400,
        );

        if (response.statusCode == 200) {
          widget.database.replace(responseData["user"]).then((data) {
            //Saving data from response to SQLite table
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MainNavigation(
                      database: widget.database,
                      userId: responseData["user"]["userId"],
                      width: widget.width,
                      height: widget.height)),
            );
          });
        }
      }
    } catch (error) {
      if (mounted) {
       debugPrint("Signup error: $error"); // Debug error
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
                  SizedBox(height: widget.height * 0.06),
                  Icon(
                    Icons.recycling_sharp,
                    size: widget.height * 0.09,
                    color: logoColor,
                  ),
                  SizedBox(height: widget.height * 0.06),
                  const Text(
                    "Let's create your account",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: widget.height * 0.03),
                  MyTextField(
                    controller: usernameController,
                    hintText: "Username",
                  ),
                  SizedBox(height: widget.height * 0.01),
                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                  ),
                  SizedBox(height: widget.height * 0.01),
                  MyTextField(
                    controller: pwdController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  SizedBox(height: widget.height * 0.01),
                  MyTextField(
                    controller: confirmPwdController,
                    hintText: "Confirm Password",
                    obscureText: true,
                  ),
                  SizedBox(height: widget.height * 0.03),
                  CButton(
                    onTap: signUp,
                    text: "Sign Up",
                  ),
                  SizedBox(height: widget.height * 0.06),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      SizedBox(width: widget.height * 0.005),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(
                                  database: widget.database,
                                  height: widget.height,
                                  width: widget.width),
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
