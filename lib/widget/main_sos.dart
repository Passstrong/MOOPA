import 'package:flutter/material.dart';
import 'package:tongmoopa/utlity/my_style.dart';
import 'package:tongmoopa/widget/sos_detail.dart';

class MainSOS extends StatefulWidget {
  @override
  _MainSOSState createState() => _MainSOSState();
}

class _MainSOSState extends State<MainSOS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOS Nearby Request for Helper'),
      ),
      drawer: Drawer(
        child: MyStyle().mySignOut(context),
      ),
      body: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SOSDetail())),
              child: ListTile(
            title: Text('คำร้องตัวอย่าง'),
            trailing: Icon(Icons.remove_red_eye),
          )),
        ],
      ),
    );
  }
}
