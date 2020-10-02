import 'package:flutter/material.dart';
import 'package:tongmoopa/utlity/my_style.dart';

class MainSOS extends StatefulWidget {
  @override
  _MainSOSState createState() => _MainSOSState();
}

class _MainSOSState extends State<MainSOS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main SOS'),
      ),drawer: Drawer(child: MyStyle().mySignOut(context),),
    );
  }
}
