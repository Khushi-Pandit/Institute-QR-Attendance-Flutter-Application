import 'package:flutter/material.dart';
import 'package:softwareproject/homescreen/homescreen.dart';
// import 'login.dart';
// import 'profilescreen.dart';

void main(){
  return runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
        // home : LoginClass(),
      home: HomeScreen(),
      // home: ProfileScreen(),
    ),
  );
}