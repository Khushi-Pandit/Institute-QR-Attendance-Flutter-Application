import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = 'John Doe';
  String email = 'john.doe@example.com';
  String phone = '+123 456 7890';
  String location = 'New York, USA';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200], // Soft background color
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Card(
                elevation: 4, // Subtle shadow to make it pop
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: const NetworkImage('https://via.placeholder.com/150'),
                        backgroundColor: Colors.grey[300], // Background for the image
                      ),
                      const SizedBox(height: 10),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildProfileTile(
                      leadingIcon: Icons.person,
                      title: 'Name',
                      subtitle: name,
                      onPressed: () => _editProfileField('Name', name, (value) {
                        setState(() {
                          name = value;
                        });
                      }),
                    ),
                    _buildProfileTile(
                      leadingIcon: Icons.email,
                      title: 'Email',
                      subtitle: email,
                      onPressed: () => _editProfileField('Email', email, (value) {
                        setState(() {
                          email = value;
                        });
                      }),
                    ),
                    _buildProfileTile(
                      leadingIcon: Icons.phone,
                      title: 'Phone',
                      subtitle: phone,
                      onPressed: () => _editProfileField('Phone', phone, (value) {
                        setState(() {
                          phone = value;
                        });
                      }),
                    ),
                    _buildProfileTile(
                      leadingIcon: Icons.location_city,
                      title: 'Location',
                      subtitle: location,
                      onPressed: () => _editProfileField('Location', location, (value) {
                        setState(() {
                          location = value;
                        });
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }

  // Reusable method to build profile list tiles
  Widget _buildProfileTile({
    required IconData leadingIcon,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 2, // Light shadow for better separation
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(leadingIcon, color: Colors.deepPurple),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.deepPurple),
          onPressed: onPressed,
        ),
      ),
    );
  }

  // Function to edit profile fields
  void _editProfileField(String title, String currentValue, Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter your $title',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
