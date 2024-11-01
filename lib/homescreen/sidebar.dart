import 'package:flutter/material.dart';
import 'package:softwareproject/functions/fuctions.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 222, 173, 238),
              ),
                child: Text(
                  'menu',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
            ),
            // SideBarList(icon: Icons.thermostat, onTapFunc: () {}, title: "Khushi"),
            // ListTile(
            //   leading: const Icon(Icons.account_balance),
            //   title:const Text("Profile"),
            //   onTap: (){},
            // ),
            // ListTile(
            //   leading:const Icon(Icons.account_balance),
            //   title:const Text("Profile"),
            //   onTap: (){},
            // ),
            // ListTile(
            //   leading:const Icon(Icons.account_balance),
            //   title:const Text("Profile"),
            //   onTap: (){},
            // ),
            // ListTile(
            //   leading:const Icon(Icons.account_balance),
            //   title:const Text("Profile"),
            //   onTap: (){},
            // ),
    );
  }
}