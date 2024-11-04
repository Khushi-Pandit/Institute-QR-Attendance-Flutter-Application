import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 222, 173, 238),
            ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
          );
  }
}