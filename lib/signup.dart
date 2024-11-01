import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isNotValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // Changed background to a gradient for a more elegant look
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
            const SizedBox(
              height: 20,
            ),
            Text(
              'Sign Up',
              style: GoogleFonts.pacifico(
                // Using a stylish font for the header
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
            SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(
                      0.9), // Added background color for input fields
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        12), // Rounded corners for a softer look
                    borderSide: BorderSide(
                      color: Colors.grey[400]!, // Soft border color
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors
                          .deepPurple[300]!, // Accent color for focused state
                      width: 2.0,
                    ),
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.grey[500]),
                  hintText: "Name",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                controller: emailController,
                obscureText: true,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey[400]!,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.deepPurple[300]!,
                      width: 2.0,
                    ),
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.grey[500]),
                  hintText: "Number/Email",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // signIn();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[300],
                  elevation: 5,
                  shadowColor: Colors.deepPurple
                      .withOpacity(0.5), // Added shadow for depth
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        12), // Rounded corners for consistency
                  ),
                ),
                child: const Text(
                  "Sign up",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginClass(),
                  ),
                );
              },
              child: Text(
                "Already have an account? LogIn",
                style: GoogleFonts.roboto(
                  // Clean and modern font for the text button
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color:
                        Colors.deepPurple, // Updated text color to match theme
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
