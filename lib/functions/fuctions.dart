import 'package:flutter/material.dart';

Widget SideBarList ({
  required icon,
  required title,
  required onTapFunc(),
}){
  return ListTile(
              leading: Icon(icon),
              title: Text(title),
              onTap: onTapFunc(),
            );
}