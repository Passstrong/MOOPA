import 'package:flutter/material.dart';
import 'package:tongmoopa/utlity/drawer_header.dart';
import 'package:tongmoopa/utlity/my_style.dart';
import 'package:tongmoopa/utlity/search_section.dart';

class HelpMe extends StatefulWidget {
  @override
  _HelpMeState createState() => _HelpMeState();
}

class _HelpMeState extends State<HelpMe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help Me',
          style: TextStyle(color: Colors.pink[100]),
        ),
        backgroundColor: Colors.blue[900],
      ),
      backgroundColor: Colors.blue.shade900,
      drawer: Drawer(
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
                      'ขอความช่วยเหลือ',
                      style: TextStyle(color: Colors.brown),
                    ),
                    subtitle: Text(
                      'คือ เมนูที่คุณสามารถส่งพิกัด และข้อความขอความช่วยเหลือได้',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ],
              ),
              MyStyle().mySignOut(context),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SearchHome(),
          ],
        ),
      ),
    );
  }
}