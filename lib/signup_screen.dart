import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recyclingapp/components/button.dart';
import 'package:recyclingapp/components/mytextfield.dart';
import 'package:recyclingapp/services/general/colors.dart';
import 'package:recyclingapp/services/general/snackbar.dart';
import 'package:recyclingapp/welcome_screen.dart';

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

  void signUp() async {
    //await dotenv.load();
    String apiUrl = "https://qeh35ldygc.execute-api.eu-central-1.amazonaws.com";

    if (pwdController.text != confirmPwdController.text) {
      showSnackbar(context, "Passwords don't match", true);
      return null;
    }

    var paramsApiUrl =
        "$apiUrl/recyclingSignUp?email=${emailController.text}&pwd=${pwdController.text}&username=${usernameController.text}";

    var response = http.post(Uri.parse(paramsApiUrl));
    response.then((http.Response response) {
      showSnackbar(context, jsonDecode(response.body)['msg'],
          response.statusCode == 400);

      if (response.statusCode == 200) {
        //saveDataToLocalStorage("userId", jsonDecode(response.body)['userId']);
        //saveDataToLocalStorage("username", usernameController.text);

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
        title: const Text('Sign Up'),
        backgroundColor: appBarColor,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
              MyTextField(controller: usernameController, hintText: "Username"),
              const SizedBox(height: 10),
              MyTextField(controller: emailController, hintText: "Email"),
              const SizedBox(height: 10),
              MyTextField(
                  controller: pwdController,
                  hintText: "Password",
                  obscureText: true),
              const SizedBox(height: 10),
              MyTextField(
                  controller: confirmPwdController,
                  hintText: "Confirm Password",
                  obscureText: true),
              const SizedBox(
                height: 25,
              ),
              CButton(onTap: signUp, text: "Sign up"),
              const SizedBox(
                height: 50,
              ),
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
                              builder: (context) => const SignUpScreen()));
                    },
                    child: const Text(
                      'Login now',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ]),
          ),
        ),
      )),
    ));
  }
}
