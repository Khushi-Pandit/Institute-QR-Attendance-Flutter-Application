import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Utils/helper/helper_functions.dart';
import '../../common/api_routes.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key, required this.qrData, required this.studentId});
  final Map<String, dynamic> qrData;
  final String studentId;

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {

  @override
  void initState() {
    super.initState();
    markAttendance();
  }

  void markAttendance() async {
    final reqBody = {
      'studentId': widget.studentId,
      'status': "Present",
      'qrData': json.encode(widget.qrData)
    };

    final response = await http.post(
      Uri.parse(markAttendanceUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(reqBody),
    );

    print(response.body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("Attendance Marked Successfully");
      HelperFunctions.showSnackBar('Marking Attendance Success!\Message: ${jsonResponse}');
    } else {
      HelperFunctions.showSnackBar('Marking Attendance failed!\nReason: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        elevation: 8,
        backgroundColor: Colors.deepPurpleAccent,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_left, size: 30, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text(
              "Attendance Status",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
