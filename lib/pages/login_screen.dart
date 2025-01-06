// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:ecofy/services/general/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:ecofy/components/button.dart';
import 'package:ecofy/components/mytextfield.dart';
import 'package:ecofy/services/general/colors.dart';
import 'package:ecofy/services/general/snackBar.dart';
import 'package:ecofy/pages/signup_screen.dart';
import 'package:ecofy/services/general/main_navigation.dart';

class LoginScreen extends StatefulWidget {
  final DatabaseService database;
  final double width;
  final double height;
  const LoginScreen(
      {super.key,
      required this.database,
      required this.height,
      required this.width});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  late String? apiUrl;

  Future<void> login() async {
    await dotenv.load();

    apiUrl = dotenv.env["httpURL"];

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
       debugPrint("Parsed Response: $responseData");

        // Display a message based on the response
        showSnackbar(context, responseData['msg'], response.statusCode == 400);

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
                        height: widget.height,
                      )),
            );
          });
        }
      }
    } catch (error) {
      if (mounted) {
        // Log the error for debugging
       debugPrint("Error occurred during login: $error");

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
                  SizedBox(height: widget.height * 0.06),
                  Icon(
                    Icons.recycling_sharp,
                    size: widget.height * 0.09,
                    color: logoColor,
                  ),
                  SizedBox(height: widget.height * 0.06),
                  const Text(
                    "Welcome back. You've been missed!",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: widget.height * 0.03),
                  MyTextField(controller: emailController, hintText: "Email"),
                  SizedBox(height: widget.height * 0.01),
                  MyTextField(
                    controller: pwdController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  SizedBox(height: widget.height * 0.03),
                  CButton(onTap: login, text: "Login"),
                  SizedBox(height: widget.height * 0.06),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      SizedBox(width: widget.height * 0.005),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(
                                  database: widget.database,
                                  height: widget.height,
                                  width: widget.width),
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
