import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softwareproject/UI/Home/HomeScreen.dart';
import 'package:softwareproject/UI/Login/LoginScreen.dart';
import 'package:softwareproject/Utils/helper/helper_functions.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        whereToGo();
      }
    });
  }

  whereToGo() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn')?? false;

    String token = prefs.getString('token')?? "";
    Map<String,dynamic> tokenData;
    try{
      tokenData = JwtDecoder.decode(token);
    } catch(e){
      tokenData = {
        "fullName": "",
        "email": ""
      };
    }

    final String fullName = tokenData['fullName'];
    final String email = tokenData['email'];

    if(isLoggedIn){
      HelperFunctions.shiftToScreen(context, HomeScreen(fullName: fullName, email: email,));
    } else {
      HelperFunctions.shiftToScreen(context, const LoginScreen());
    }
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
