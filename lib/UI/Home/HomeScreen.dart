import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softwareproject/UI/AllCourses/AllCoursesScreen.dart';
import 'package:softwareproject/UI/Login/LoginScreen.dart';
import 'package:softwareproject/UI/Profile/ProfileScreen.dart';
import 'package:softwareproject/UI/Scanner/QR_Scanner.dart';
import 'package:softwareproject/Utils/device/device_utility.dart';
import 'package:softwareproject/Utils/helper/helper_functions.dart';
import 'package:http/http.dart' as http;
import '../../common/api_routes.dart';
import '../../common/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.fullName, required this.email});
  final String fullName;
  final String email;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final wishes = [
    "Good Morning",
    "Good Afternoon",
    "Good Evening",
    "Good Night",
  ];

  String getWish(){
    int hour = DateTime.now().hour;
    int minute = DateTime.now().minute;
    if(hour<12 && hour>=5) {
      return wishes[0];
    }
    if(hour<17 && hour>=12) {
      return wishes[1];
    }
    if(hour<19 && hour>=17) {
      return wishes[2];
    }
    else {
      return wishes[3];
    }
  }

  Future<List<ClassModel>> fetchClasses() async {
    final String studentId = HelperFunctions().getUppercaseTextBeforeAt(widget.email);

    final response = await http.get(Uri.parse('$todayClassesUrl?studentId=$studentId'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List classes = jsonResponse['classes'];
      return classes.map((clas) => ClassModel.fromJson(clas)).toList();
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
        toolbarHeight: 60,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 8,
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
              size: 26,
            ),
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 26,
            ),
            onPressed: () {
              // Handle settings
            },
          ),
        ],
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurpleAccent, Colors.deepPurpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: Text(
                widget.fullName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                widget.email,
                style: const TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/icons/profile.webp'),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.account_circle,
              text: 'Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.school,
              text: 'Student',
              onTap: () {
                // Handle Student onTap
              },
            ),
            _buildDrawerItem(
              icon: Icons.check,
              text: 'Attendance',
              onTap: () {
                // Handle Attendance onTap
              },
            ),
            _buildDrawerItem(
              icon: Icons.grade,
              text: 'Score',
              onTap: () {
                // Handle Score onTap
              },
            ),
            _buildDrawerItem(
              icon: Icons.logout,
              text: 'Log Out',
              onTap: () {
                saveLoginState(false);
                HelperFunctions.shiftToScreen(context, const LoginScreen());
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(getWish(), style: TextStyle(fontSize: 14,
                      color: !Provider.of<ThemeProvider>(context).isDark ?const Color(0xFF18215B):
                      const Color(0xFFFFFFFF))),

                  Text(widget.fullName, style: Theme.of(context).textTheme.bodyLarge?.
                  merge(TextStyle(color: !Provider.of<ThemeProvider>(context).isDark ?const Color(0xFF18215B):
                  const Color(0xFFFFFFFF), fontSize: 24,))),

                ],
              ),

              const SizedBox(height: 30,),

              Text("Today's Classes", style: Theme.of(context).textTheme.titleLarge,),

              const SizedBox(height: 20,),

              FutureBuilder<List<ClassModel>>(
                future: fetchClasses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No classes available"));
                  }

                  List<ClassModel> classes = snapshot.data!;

                  return SizedBox(
                    height: 155,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: classes.length,
                      itemBuilder: (context, index) {

                        ClassModel classModel = classes[index];

                        int hour = classModel.scheduledDate.hour;
                        int minute = classModel.scheduledDate.minute;
                        String period = hour >= 12 ? 'PM' : 'AM';

                        int hour12 = hour % 12;
                        hour12 = hour12 == 0 ? 12 : hour12;

                        String timeString = '${hour12.toString().padLeft(2, '0')}:'
                            '${minute.toString().padLeft(2, '0')} $period';


                        Duration durationToAdd = Duration(minutes: classModel.duration);

                        DateTime newDateTime = classModel.scheduledDate.add(durationToAdd);

                        hour = newDateTime.hour;
                        minute = newDateTime.minute;

                        period = hour >= 12 ? 'PM' : 'AM';

                        hour12 = hour % 12;
                        hour12 = hour12 == 0 ? 12 : hour12;

                        String endTimeString = '${hour12.toString().padLeft(2, '0')}:'
                            '${minute.toString().padLeft(2, '0')} $period';

                        return Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(8),
                          width: 140,
                          decoration: BoxDecoration(
                              color: Provider.of<ThemeProvider>(context).isDark ?index==0?Colors.deepPurpleAccent.shade100: const Color(
                                  0xFF000811):
                              index==0?Colors.deepPurpleAccent.shade100: Colors.white,
                              border: Border.all(
                                color: Colors.black12,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(classModel.courseName, textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyLarge?.merge(TextStyle(color: Colors.purple[900])),),

                              const SizedBox(height: 10,),

                              Text('$timeString - $endTimeString', textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: Colors.purple[900], fontWeight: FontWeight.w500)),),

                              Text('Duration: ${classModel.duration.toString()} Min', textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: Colors.purple[900], fontWeight: FontWeight.w500)),),

                              const SizedBox(height: 10,),

                              SizedBox(
                                height: 30,
                                width: 80,
                                child: ElevatedButton(
                                    onPressed: (){
                                      // HelperFunctions.navigateToScreen(context, SubCategoryScreen(category: todoListext[index], moduleNo: index+1));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: index==0?Colors.white: null,
                                      foregroundColor: index==0?Colors.purple[900]:null,
                                      elevation: 0,
                                      padding: const EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Details', style: TextStyle(fontSize: 12),),
                                        Icon(Icons.fast_forward_rounded)
                                      ],
                                    )
                                ),
                              ),

                              const SizedBox(height: 5,),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 30,),

              GestureDetector(
                onTap: (){
                  HelperFunctions.navigateToScreen(context, AllCoursesScreen(email: widget.email,));
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(8),
                  width: DeviceUtils.getScreenSize(context).width,
                  decoration: BoxDecoration(
                      color: Provider.of<ThemeProvider>(context).isDark ?const Color(
                          0xFF000811):
                      Colors.white,
                      border: Border.all(
                        color: Colors.black12,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                          child: Image.asset("assets/images/a3.png")
                      ),
                      const SizedBox(height: 10,),
                      Text("My Registered Courses", style: Theme.of(context).textTheme.headlineSmall,)
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18,),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){},
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(8),
                      width: DeviceUtils.getScreenSize(context).width*0.41,
                      decoration: BoxDecoration(
                          color: Provider.of<ThemeProvider>(context).isDark ?const Color(
                              0xFF000811):
                          Colors.white,
                          border: Border.all(
                            color: Colors.black12,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 100,
                              child: Image.asset("assets/images/lab.png")
                          ),
                          const SizedBox(height: 10,),
                          Text("My Lab Activity", style: Theme.of(context).textTheme.headlineSmall,)
                        ],
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: (){},
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(8),
                      width: DeviceUtils.getScreenSize(context).width*0.41,
                      decoration: BoxDecoration(
                          color: Provider.of<ThemeProvider>(context).isDark ?const Color(
                              0xFF000811):
                          Colors.white,
                          border: Border.all(
                            color: Colors.black12,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 100,
                              child: Image.asset("assets/images/library.png")
                          ),
                          const SizedBox(height: 10,),
                          Text("My Library Activity", style: Theme.of(context).textTheme.headlineSmall,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30,),




            ],
          ),
        ),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final cameras = await availableCameras();
          if (cameras.isEmpty) {
            print('No available cameras');
          } else {
            HelperFunctions.navigateToScreen(context, QRCodeScanner(studentId: HelperFunctions().getUppercaseTextBeforeAt(widget.email),));
          }
        },
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(
          Icons.qr_code_scanner,
          color: Colors.white,
          size: 30, // Larger icon size
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // More accessible position
    );
  }


  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,}) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurpleAccent, size: 28),
      title: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: onTap,
    );
  }

}


class ClassModel {
  final String id;
  final String courseName;
  final String courseCode;
  final DateTime scheduledDate;
  final int duration;
  final String classTopic;

  ClassModel({
    required this.id,
    required this.courseName,
    required this.courseCode,
    required this.scheduledDate,
    required this.duration,
    required this.classTopic,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['_id'],
      courseName: json['courseDetails']['courseName'],
      courseCode: json['courseDetails']['courseCode'],
      scheduledDate: DateTime.parse(json['scheduledDate'] ?? json['scheduledDate']),
      duration: json['duration'],
      classTopic: json['classTopic'],
    );
  }
}



void saveLoginState(bool state) async {
  final prefs = await SharedPreferences.getInstance();
  if(state==false){
    prefs.setString('token', '');
  }
  await prefs.setBool('isLoggedIn', state);
}
