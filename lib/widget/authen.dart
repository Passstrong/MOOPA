import 'package:flutter/material.dart';
import 'package:tongmoopa/widget/register.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Colors.green.shade100,
              Colors.blue.shade900,
            ],
            radius: 1,
            center: Alignment(0, -0.3),
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildLogo(),
                    buildText(),
                    buildUser(),
                    buildPassword(),
                    // buildLogin() ???
                    buildContainer()
                  ],
                ),
              ),
            ),
            buildNewRegis()
          ],
        ),
      ),
    );
  }

  Column buildNewRegis() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Register(),
                  )),
              child: Text(
                'New register',
                style: TextStyle(
                  color: Colors.pink,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Container buildContainer() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: RaisedButton(
          onPressed: null,
          child: Text(
            'login',
            style: TextStyle(
              color: Colors.yellow.shade100,
            ),
          )),
    );
  }

// Test???shortkey..
// class Name { ???
  // Widget
// }

// Container ???

  Container buildUser() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'User :',
          suffixIcon: Icon(Icons.account_circle),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password :',
          suffixIcon: Icon(Icons.remove_red_eye),
        ),
      ),
    );
  }

  Text buildText() => Text(
        'MOOPA',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          // fontStyle: FontStyle.italic,
          color: Colors.brown.shade500,
        ),
      );

  Container buildLogo() {
    return Container(
      width: 190,
      child: Image.asset('images/theone.jpg'),
    );
  }
}

// buildLogin() { ???
// }
