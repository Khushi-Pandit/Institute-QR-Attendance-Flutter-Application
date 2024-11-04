import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'package:softwareproject/common/api_routes.dart';

import '../../Utils/device/device_utility.dart';

class AttendanceDetailScreen extends StatefulWidget {
  const AttendanceDetailScreen({super.key, required this.studentId, required this.course});
  final String studentId;
  final Map<String, dynamic> course;

  @override
  State<AttendanceDetailScreen> createState() => _AttendanceDetailScreenState();
}

class _AttendanceDetailScreenState extends State<AttendanceDetailScreen> {
  List<DateTime> presentDates = [];
  List<DateTime> absentDates = [];
  List<DateTime> futureClassDates = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceData().then((nothing){
      _fetchFutureClasses();
    });
  }


  Future<void> _fetchAttendanceData() async {
    try {
      final response = await http.get(Uri.parse('$attendanceDetailsUrl?studentId=${widget.studentId}&courseId=${widget.course['id']}'));
      if (response.statusCode == 200) {
        List attendanceData = json.decode(response.body)['attendance'];
        setState(() {
          for (var attendance in attendanceData) {
            DateTime date = DateTime.parse(attendance['classSchedule']['scheduledDate']);

            if (attendance['status'] == 'Present') {
              presentDates.add(date);
            } else {
              absentDates.add(date);
            }
          }
        });
      }
    } catch (e) {
      print('Error fetching attendance: $e');
    }
  }

  Future<void> _fetchFutureClasses() async {
    try {
      final response = await http.get(Uri.parse('$classSchedulesUrl?courseId=${widget.course['id']}'));
      if (response.statusCode == 200) {
        List classesData = json.decode(response.body)['classes'];
        setState(() {
          for (var classInfo in classesData) {
            DateTime classDate = DateTime.parse(classInfo['scheduledDate']);

            if (classDate.isAfter(DateTime.now()) || classDate.isAtSameMomentAs(DateTime.now())) {
              if(!presentDates.contains(classDate) && !absentDates.contains(classDate)){
                futureClassDates.add(classDate);
              }
            }
          }
        });
      }
    } catch (e) {
      print('Error fetching future classes: $e');
    }
  }

  bool _isDateInList(DateTime day, List<DateTime> dateList) {
    return dateList.any((d) => d.year == day.year && d.month == day.month && d.day == day.day);
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
            Text(
              widget.course['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarFormat: CalendarFormat.month,
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                eventLoader: (day) {
                  if (_isDateInList(day, presentDates)) {
                    return ['Present'];
                  } else if (_isDateInList(day, absentDates)) {
                    return ['Absent'];
                  } else if (_isDateInList(day, futureClassDates)) {
                    return ['Future'];
                  }
                  return [];
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.green
                  ),
                  titleCentered: true,
                  titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isEmpty) return null;

                    Color dotColor;
                    if (events.contains('Present')) {
                      dotColor = Colors.green;
                    } else if (events.contains('Absent')) {
                      dotColor = Colors.red;
                    } else {
                      dotColor = Colors.yellow;
                    }

                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 6.0,
                        height: 6.0,
                        decoration: BoxDecoration(
                          color: dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendDot(Colors.green, "Present"),
                    const SizedBox(width: 20),
                    _buildLegendDot(Colors.red, "Absent"),
                    const SizedBox(width: 20),
                    _buildLegendDot(Colors.yellow, "Scheduled"),
                  ],
                ),
              ),

              const SizedBox(height: 20,),
              
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('UPCOMING CLASSES', style: Theme.of(context).textTheme.bodyLarge,),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Text(futureClassDates.length.toString(), style: Theme.of(context).textTheme.bodyMedium,),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 150,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.green.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('  TOTAL PRESENT  ', style: Theme.of(context).textTheme.bodyLarge,),
                        Text(presentDates.length.toString(), style: Theme.of(context).textTheme.headlineLarge,)
                      ],
                    ),
                  ),

                  Container(
                    height: 150,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.red.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('  TOTAL ABSENT  ', style: Theme.of(context).textTheme.bodyLarge,),
                        Text(absentDates.length.toString(), style: Theme.of(context).textTheme.headlineLarge,)
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20,),

              Container(
                width: DeviceUtils.getScreenSize(context).width,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black12, width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('COURSE DETAILS', style: Theme.of(context).textTheme.headlineSmall,),
                        SizedBox(height: 30, width: 30 ,child: Image.asset('assets/images/a3.png'))
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Container(width: DeviceUtils.getScreenSize(context).width,color: Colors.black, height: 1,),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Course Code", style: Theme.of(context).textTheme.bodyMedium,),
                        Text(widget.course['code'], style: Theme.of(context).textTheme.bodyLarge,),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Course ID", style: Theme.of(context).textTheme.bodyMedium,),
                        Text(widget.course['id'], style: Theme.of(context).textTheme.bodyLarge,),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Instructor Name", style: Theme.of(context).textTheme.bodyMedium,),
                        Text(widget.course['instructor'], style: Theme.of(context).textTheme.bodyLarge,),
                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendDot(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(text),
      ],
    );
  }
}
