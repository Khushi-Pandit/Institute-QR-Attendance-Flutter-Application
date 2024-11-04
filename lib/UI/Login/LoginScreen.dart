import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softwareproject/UI/Home/HomeScreen.dart';
import 'package:softwareproject/UI/SignUp/SignUp.dart';
import 'package:http/http.dart' as http;
import 'package:softwareproject/Utils/helper/helper_functions.dart';
import 'package:softwareproject/common/api_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      final reqBody = {
        'email': emailController.text,
        'password': passwordController.text,
        'role': "student"
      };

      final response = await http.post(
        Uri.parse(loginUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(reqBody),
      );

      print(response.body);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();

        final token = await jsonResponse['token'];
        await prefs.setString('token', token);
        await prefs.setBool('isLoggedIn', true);

        Map<String,dynamic> tokenData = JwtDecoder.decode(token);
        final String fullName = tokenData['fullName'];
        final String email = tokenData['email'];
        print("Token: ${jsonResponse['token']}\nName: $fullName");

        setState(() {
          isLoading = false;
        });

        HelperFunctions.shiftToScreen(context, HomeScreen(fullName: fullName, email: email,));
        HelperFunctions.showAlert("IIIT Student", "Sign in Successful.");
      } else {
        setState(() {
          isLoading = false;
        });
        HelperFunctions.showSnackBar('Signup failed!\nReason: ${response.body}');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      HelperFunctions.showSnackBar('Enter Valid Data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF3E5F5),
              Color(0xFFE1BEE7),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Sign In',
              style: GoogleFonts.pacifico(
                textStyle: const TextStyle(
                  fontSize: 36,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 4,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            // Email input field with matching style
            SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email, color: Colors.grey[500]),
                  hintText: "Email Address",
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                controller: passwordController,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Colors.grey[500]),
                  hintText: "Password",
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading? (){} : (){
                  loginUser();
                },
                child: isLoading? const SizedBox(
                  width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.purple, strokeWidth: 1,)
                ) : const Text(
                  "Sign In",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                HelperFunctions.navigateToScreen(context, const SignupScreen());
              },
              child: Text(
                "Create new Account? SignUp",
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple, // Matching link color
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

