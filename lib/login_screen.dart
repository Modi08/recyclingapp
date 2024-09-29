import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:recyclingapp/components/button.dart';
import 'package:recyclingapp/components/mytextfield.dart';
import 'package:http/http.dart' as http;
import 'package:recyclingapp/services/general/snackBar.dart';
import 'package:recyclingapp/signup_screen.dart';
import 'package:recyclingapp/welcome_screen.dart';

/*
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
        backgroundColor: const Color.fromARGB(255, 205, 254, 206),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Log In Page',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add your log-in logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('Log In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

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
            MaterialPageRoute(builder: (context) => const WelcomeScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      child: Scaffold(
        appBar: AppBar(
            title: const Text("Login"),
            backgroundColor: const Color.fromARGB(255, 222, 255, 222)),
        body: SafeArea(
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
                      color: Colors.grey[800],
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
