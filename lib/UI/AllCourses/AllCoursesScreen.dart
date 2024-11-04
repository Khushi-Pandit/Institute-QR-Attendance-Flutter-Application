import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:softwareproject/common/api_routes.dart';
import '../../Utils/device/device_utility.dart';
import '../../Utils/helper/helper_functions.dart';
import '../../common/theme_provider.dart';
import '../AttendanceDetails/AttendanceDetailScreen.dart';

class AllCoursesScreen extends StatefulWidget {
  const AllCoursesScreen({super.key, required this.email});
  final String email;

  @override
  State<AllCoursesScreen> createState() => _AllCoursesScreenState();
}

class _AllCoursesScreenState extends State<AllCoursesScreen> {
  bool isLoading = false;
  TextEditingController queryController = TextEditingController();
  List<Course> allCourses = [];
  List<Course> filteredCourses = [];

  @override
  void initState() {
    super.initState();

    fetchCourses().then((courses) {
      setState(() {
        allCourses = courses;
        filteredCourses = courses;
        isLoading = false;
      });
    });

    queryController.addListener(_filterCourses);
  }

  void _filterCourses() {
    setState(() {
      filteredCourses = allCourses
          .where((course) =>
          course.courseName.toLowerCase().contains(queryController.text.toLowerCase()))
          .toList();
    });
  }

  Future<List<Course>> fetchCourses() async {
    setState(() {
      isLoading = true;
    });
    final String studentId = HelperFunctions().getUppercaseTextBeforeAt(widget.email);

    final response = await http.get(Uri.parse('$studentCoursesUrl?studentId=$studentId'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<dynamic> coursesJson = jsonResponse['courses'];
      return coursesJson.map((json) => Course.fromJson(json)).toList();
    } else {
      final jsonResponse = json.decode(response.body);
      HelperFunctions.showSnackBar(jsonResponse);
    }

    return [];
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
              onTap: (){
                Navigator.pop(context);
              },
                child: const Icon(Icons.arrow_left, size: 30, color: Colors.white,)
            ),
            const SizedBox(width: 10,),
            const Text(
              "My Registered Courses",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [

            const SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: DeviceUtils.getScreenSize(context).width*0.8,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Provider.of<ThemeProvider>(context).isDark ? const Color(
                          0xFF000811):
                      Colors.white,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: TextField(
                    controller: queryController,
                    decoration: InputDecoration(
                        hintText: 'Search courses',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: _filterCourses,
                        ),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                        errorBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                        focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                        errorStyle: const TextStyle(fontSize: 0)
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20,),

            isLoading? SizedBox(height: 5,width: DeviceUtils.getScreenSize(context).width ,child: const LinearProgressIndicator()): Expanded(
                child: filteredCourses.isEmpty
                    ? const Center(child: Text("No courses available"))
                    : buildListView(filteredCourses),
            )

          ],
        ),
      )
    );
  }

  Widget buildListView(List<Course> courses) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return CourseWidget(
          course: {
          'name': courses[index].courseName,
          'code': courses[index].courseCode,
          'id': courses[index].courseId.toString(),
          'instructor': courses[index].professorName
        },
          studentId: HelperFunctions().getUppercaseTextBeforeAt(widget.email),
        );
      },
    );
  }

  Widget buildGridView(List<Course> courses) {
    return GridView.builder(
      itemCount: courses.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8),
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  courses[index].courseName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("Code: ${courses[index].courseCode}"),
                Text("Professor: ${courses[index].professorName}"),
                const SizedBox(height: 4),
                Text("Batch: ${courses[index].batch}"),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CourseWidget extends StatefulWidget {
  const CourseWidget({super.key, required this.course, required this.studentId});
  final Map<String, dynamic> course;
  final String studentId;

  @override
  State<CourseWidget> createState() => _CourseWidgetState();
}

class _CourseWidgetState extends State<CourseWidget> {
  bool _isOpen = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      padding: const EdgeInsets.all(15),
      width: DeviceUtils.getScreenSize(context).width,
      decoration: BoxDecoration(
          color: Provider.of<ThemeProvider>(context).isDark ? const Color(
              0xFF000811):
          Colors.white,
          border: Border.all(color: Colors.black12, width: 1),
          borderRadius: BorderRadius.circular(5)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(widget.course['name'],
                  style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(color: Colors.deepPurpleAccent[200], fontWeight: FontWeight.w600)),),
              )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Container(
                padding: const EdgeInsets.all(5),
                width: DeviceUtils.getScreenSize(context).width*0.15,
                decoration: BoxDecoration(
                    color: Provider.of<ThemeProvider>(context).isDark ? const Color(
                        0xFF000811):
                    Colors.white,
                    border: Border.all(
                      color: Colors.black12,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(3)
                ),
                child: Column(
                  children: [
                    Text("ID", style: Theme.of(context).textTheme.bodySmall?.merge(const TextStyle(color: Colors.black45))),
                    Text(widget.course['id'], style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(5),
                width: DeviceUtils.getScreenSize(context).width*0.2,
                decoration: BoxDecoration(
                    color: Provider.of<ThemeProvider>(context).isDark ? const Color(
                        0xFF000811):
                    Colors.white,
                    border: Border.all(
                      color: Colors.black12,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(3)
                ),
                child: Column(
                  children: [
                    Text("Code", style: Theme.of(context).textTheme.bodySmall?.merge(const TextStyle(color: Colors.black45))),
                    Text(widget.course['code'], style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),

              SizedBox(
                height: 35,
                width: 125,
                child: ElevatedButton(
                    onPressed: (){
                      HelperFunctions.navigateToScreen(context, AttendanceDetailScreen(
                        studentId: widget.studentId, course: widget.course,));
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0, // no elevation
                      padding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('View Attendance', style: TextStyle(fontSize: 12),),
                        Icon(Icons.arrow_right, size: 18,)
                      ],
                    )
                ),
              )
            ],
          ),

          Visibility(visible: _isOpen, child: const SizedBox(height: 5,)),

          Visibility(
            visible: _isOpen,
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: DeviceUtils.getScreenSize(context).width,
                decoration: BoxDecoration(
                  color: Provider.of<ThemeProvider>(context).isDark ? const Color(
                      0xFF000811):
                  Colors.white,
                ),
                child: Column(
                  children: [

                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Provider.of<ThemeProvider>(context).isDark ? const Color(
                              0xFF000811):
                          Colors.white,
                          border: Border.all(color: Colors.black12, width: 1),
                          borderRadius: BorderRadius.circular(3)
                      ),
                      child: Row(children: [
                        Expanded(child: Text("Instructor Name", style: Theme.of(context).textTheme.bodySmall?.merge(const TextStyle(color: Colors.black45)))),
                        Expanded(child: Text(widget.course['instructor'], style: Theme.of(context).textTheme.bodySmall)),
                      ],),
                    ),

                  ],
                )
            ),
          ),

        ],
      ),
    );
  }
}

class Course {
  final int courseId;
  final String courseCode;
  final String courseName;
  final int batch;
  final String professorName;

  Course({
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.batch,
    required this.professorName,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['courseId'],
      courseCode: json['courseCode'],
      courseName: json['courseName'],
      batch: json['batch'],
      professorName: json['professorName'],
    );
  }
}
