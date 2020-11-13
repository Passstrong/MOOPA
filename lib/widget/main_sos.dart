import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:tongmoopa/utlity/scoped_models/app_model.dart';
import 'package:tongmoopa/utlity/my_style.dart';
import 'package:tongmoopa/widget/help_list.dart';

class MainSOS extends StatefulWidget {
  @override
  _MainSOSState createState() => _MainSOSState();
}

class _MainSOSState extends State<MainSOS> {
  AppModel user;
  Timer timer;
  List<QueryDocumentSnapshot> list;

  @override
  void initState() {
    super.initState();
    user = ScopedModel.of<AppModel>(context, rebuildOnChange: false);
    readUserData(user);
    checkHelpMeList();
    timer =
        Timer.periodic(Duration(seconds: 5), (Timer t) => checkHelpMeList());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkHelpMeList() async {
    final user = ScopedModel.of<AppModel>(context, rebuildOnChange: false);
    await FirebaseFirestore.instance
        .collection('HelpME')
        .where('Group', isEqualTo: user.department)
        .where('Status', isEqualTo: 0)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        setState(() {
          list = querySnapshot.docs;
        });
      } else {
        setState(() {
          list = null;
        });
      }
    });
  }

  Future<void> readUserData(AppModel user) async {
    await Firebase.initializeApp().then((value) async {
      print('***** INITIAL SUCCESS ******');
      FirebaseAuth.instance.authStateChanges().listen((event) async {
        if (event != null) {
          String uid = event.uid;
          FirebaseFirestore.instance
              .collection('User')
              .doc(uid)
              .snapshots()
              .listen((event) {
            user.setName(event.data()['Name']);
            user.setEmail(event.data()['Email']);
            user.setBirth(event.data()['Birth']);
            user.setGender(event.data()['Gender']);
            user.setLastName(event.data()['LastName']);
            user.setAge(event.data()['Age']);
            user.setImage(event.data()['UrlAvatar']);
            user.setDepartmentNumber(event.data()['department_number']);
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HERO (level Helper)'),
      ),
      drawer: Drawer(
        child: MyStyle().mySignOut(context),
      ),
      body: list != null && list.length > 0
          ? ListView.builder(
              itemCount: list.length,
              itemBuilder: (ctx, idx) {
                var data = list[idx].data();
                return ListTile(
                  title: Text('${data['Email']}'),
                  subtitle: Text(
                    'status: ' +
                        (data['Status'] == 0
                            ? 'งานใหม่'
                            : (data['Status'] == 1 ? 'รับงานแล้ว' : 'ปฎิเสธ')) +
                        '\n' +
                        '${data['Latitude']}   ${data['Longittude']}',
                  ),
                  isThreeLine: true,
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HelpMeList(
                          userEmail: data['Email'],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : Center(child: Text('ไม่มึงานในตอนนี้')),
    );
  }
}
