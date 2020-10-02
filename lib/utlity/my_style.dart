import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tongmoopa/widget/authen.dart';

class MyStyle {
  Widget mySignOut(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.red.shade700),
            child: ListTile(
              onTap: () async {
                await Firebase.initializeApp().then((value) async {
                  await FirebaseAuth.instance
                      .signOut()
                      .then((value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Authen(),
                          ),
                          (route) => false));
                });
              },
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              title: Text(
                'Sign Out',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );

  MyStyle();
}
