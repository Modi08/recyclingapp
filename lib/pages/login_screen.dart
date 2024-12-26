// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:ecofy/services/general/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecofy/components/button.dart';
import 'package:ecofy/components/mytextfield.dart';
import 'package:ecofy/services/general/colors.dart';
import 'package:ecofy/services/general/snackBar.dart';
import 'package:ecofy/pages/signup_screen.dart';
import 'package:ecofy/services/general/main_navigation.dart'; // Import MainNavigation

class LoginScreen extends StatefulWidget {
  final DatabaseService databaseService;
  const LoginScreen({super.key, required this.databaseService});

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
      // Make the API request
      var response = await http.put(Uri.parse(paramsApiUrl));

      // Log the raw response for debugging
      //print("Raw Response: ${response.body}");

      if (mounted) {
        // Parse the response
        var responseData = jsonDecode(response.body);

        // Log the parsed response for further debugging
        //print("Parsed Response: $responseData");

        // Display a message based on the response
        showSnackbar(context, responseData['msg'], response.statusCode == 400);

        if (response.statusCode == 200) {
          widget.databaseService.replace(responseData["user"]).then((data) {
            //Saving data from response to SQLite table
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MainNavigation(databaseService: widget.databaseService)),
            );
          });
        }
      }
    } catch (error) {
      if (mounted) {
        // Log the error for debugging
        print("Error occurred during login: $error");

        // Display a general error message to the user
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
                              builder: (context) => SignUpScreen(databaseService: widget.databaseService),
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
