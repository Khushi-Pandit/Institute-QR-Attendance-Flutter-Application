import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:softwareproject/UI/Login/LoginScreen.dart';
import 'package:softwareproject/Utils/device/device_utility.dart';
import 'package:softwareproject/Utils/helper/helper_functions.dart';
import 'package:softwareproject/common/api_routes.dart';

class CourseSelection extends StatefulWidget {
  const CourseSelection({super.key, required this.fullName, required this.studentId, required this.email, required this.mobile, required this.password, required this.batchCode});
  final String fullName;
  final String studentId;
  final String email;
  final String mobile;
  final String password;
  final int batchCode;

  @override
  State<CourseSelection> createState() => _CourseSelectionState();
}

class _CourseSelectionState extends State<CourseSelection> {
  late Future<List<Course>> futureCourses;
  List<Course> allCourses = [];
  List<Course> selectedCourses = [];
  String searchQuery = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    futureCourses = fetchCourses();
  }

  Future<List<Course>> fetchCourses() async {
    final response = await http.get(Uri.parse(allCoursesUrl));

    if (response.statusCode == 200) {
      final List jsonResponse = json.decode(response.body);
      return jsonResponse.map((course) => Course.fromJson(course)).toList();
    } else {
      final jsonResponse = json.decode(response.body);
      HelperFunctions.showSnackBar(jsonResponse['message']);
    }
    return [];
  }

  void doSignUp() async {
    setState(() {
      isLoading = true;
    });
    List<int> selectedCourseIds = selectedCourses.map((course) => course.courseId).toList();

    final reqBody = {
      'fullName': widget.fullName,
      'studentId': widget.studentId,
      'email': widget.email,
      'mobileNo': widget.mobile,
      'password': widget.password,
      'batchCode': widget.batchCode,
      'courses': selectedCourseIds,
    };

    final response = await http.post(
      Uri.parse(signUpUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(reqBody),
    );

    if (response.statusCode == 201) {
      setState(() {
        isLoading = false;
      });
      HelperFunctions.shiftToScreen(context, const LoginScreen());
      HelperFunctions.showAlert("IIIT Student", "Signup Successful.");
    } else {
      setState(() {
        isLoading = false;
      });
      HelperFunctions.showSnackBar('Signup failed!\nReason: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 50,),

                Text('Select Courses', style: GoogleFonts.pacifico(
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
                const SizedBox(height: 30),

                FutureBuilder<List<Course>>(
                  future: futureCourses,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    allCourses = snapshot.data!;
                    final filteredCourses = allCourses.where((course) {
                      return course.courseName.toLowerCase().contains(searchQuery.toLowerCase());
                    }).toList();

                    return Column(
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search courses',
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                        ),


                        SizedBox(
                          height: 400,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                            itemCount: filteredCourses.length,
                            itemBuilder: (context, index) {
                              final course = filteredCourses[index];
                              return CheckboxListTile(
                                title: Text('${course.courseName} (${course.courseCode})'),
                                value: selectedCourses.contains(course),
                                onChanged: (isSelected) {
                                  setState(() {
                                    if (isSelected == true) {
                                      selectedCourses.add(course);
                                    } else {
                                      selectedCourses.remove(course);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),

                SizedBox(
                  width: DeviceUtils.getScreenSize(context).width,
                  child: ElevatedButton(
                      onPressed: isLoading? (){} : (){
                        doSignUp();
                      },
                      child: isLoading? const CircularProgressIndicator(color: Colors.purple,) : const Text("Continue")
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}


class Course {
  final String id;
  final int courseId;
  final int batch;
  final String courseCode;
  final String courseName;

  Course({
    required this.id,
    required this.courseId,
    required this.batch,
    required this.courseCode,
    required this.courseName,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'],
      courseId: json['courseId'],
      batch: json['batch'],
      courseCode: json['courseCode'],
      courseName: json['courseName'],
    );
  }

}
