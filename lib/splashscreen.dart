import 'package:flutter/material.dart';
import 'login.dart';
import 'package:softwareproject/homescreen/homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(seconds: 5), (){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const Login(),
          ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 243, 210, 252),
              Color.fromARGB(255, 244, 219, 252),
              // Color.fromARGB(255, 253, 223, 255),
              // Color.fromARGB(255, 255, 231, 255)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('name'),
            const Text('Hi',
              style: TextStyle(
                fontSize: 30,
            ),),
          ],
        ),
      ),
    );
  }
}
