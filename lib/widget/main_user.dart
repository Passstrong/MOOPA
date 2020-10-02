import 'package:flutter/material.dart';
import 'package:tongmoopa/utlity/my_style.dart';

class MainUser extends StatefulWidget {
  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main User'),
      ),drawer: Drawer(child: MyStyle().mySignOut(context),),
    );
  }
}
