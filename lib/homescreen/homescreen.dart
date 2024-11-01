import 'package:flutter/material.dart';
import 'package:softwareproject/profilescreen.dart';
import 'package:softwareproject/scanqrcode.dart';
import 'package:camera/camera.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> registeredCourses = [
    'Course 1',
    'Course 2',
    'Course 3',
    'Course 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 8, // Slight shadow for depth
        title: const Text(
          'Courses',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24, // Increased size for more emphasis
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
              size: 26, // Size adjusted for better visibility
            ),
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 26, // Slightly larger icon
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
              accountName: const Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: const Text(
                'john.doe@example.com',
                style: TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage('https://example.com/profile-pic.jpg'),
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
                // Handle Log Out onTap
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: registeredCourses.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 12.0), // More space between cards
              elevation: 6, // Added elevation for a modern feel
              shadowColor: Colors.deepPurpleAccent.withOpacity(0.3), // Light shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(20.0), // Larger padding
                title: Text(
                  registeredCourses[index],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward, color: Colors.deepPurpleAccent),
                onTap: () {
                  print('Tapped on ${registeredCourses[index]}');
                  // Add navigation logic here
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final cameras = await availableCameras();
          if (cameras.isEmpty) {
            print('No available cameras');
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QRCodeScanner()),
            );
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

  // Helper function to build drawer items
  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurpleAccent, size: 28),
      title: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: onTap,
    );
  }
}
