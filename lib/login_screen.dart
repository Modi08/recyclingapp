import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recyclingapp/components/button.dart';
import 'package:recyclingapp/components/mytextfield.dart';
import 'package:http/http.dart' as http;
import 'package:recyclingapp/profile_screen.dart';
import 'package:recyclingapp/services/general/colors.dart';
import 'package:recyclingapp/services/general/snackBar.dart';
import 'package:recyclingapp/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final pwdController = TextEditingController();

  void login() async {
    //await dotenv.load();
    String apiUrl = "https://qeh35ldygc.execute-api.eu-central-1.amazonaws.com";

    var paramsApiUrl =
        "$apiUrl/recyclingLoginApp?email=${emailController.text}&pwd=${pwdController.text}";

    var response = http.put(Uri.parse(paramsApiUrl));
    response.then((http.Response response) {
      print(response.body);
      showSnackbar(context, jsonDecode(response.body)['msg'],
          response.statusCode == 400);

      if (response.statusCode == 200) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login"), backgroundColor: appBarColor),
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
                      "Welcome back. You' ve been missed!",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 25),
                    MyTextField(controller: emailController, hintText: "Email"),
                    const SizedBox(height: 10),
                    MyTextField(
                        controller: pwdController,
                        hintText: "Password",
                        obscureText: true),
                    const SizedBox(
                      height: 25,
                    ),
                    CButton(onTap: login, text: "Login"),
                    const SizedBox(
                      height: 50,
                    ),
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
                                    builder: (context) =>
                                        const SignUpScreen()));
                          },
                          child: const Text(
                            'Register now',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
