import 'package:flutter/material.dart';
import 'package:tongmoopa/utlity/drawer_header.dart';
import 'package:tongmoopa/utlity/my_style.dart';

class DrawerBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
          color: Colors.blue[100],
          child: Stack(
            children: [
              Column(
                children: [
                  AppDrawerHeader(),
                  ListTile(
                    leading: Icon(
                      Icons.star,
                      color: Colors.brown,
                    ),
                    title: Text(
                      'Help Me list',
                      style: TextStyle(color: Colors.brown),
                    ),
                    subtitle: Text(
                      'Use Full Version (next Version 2.0 coming)',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ],
              ),
              MyStyle().mySignOut(context),
            ],
          ),
        ),
      );
  }
}