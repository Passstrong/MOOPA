import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tongmoopa/utlity/normal_dialog.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  File file;

  String urlAvatar, name, lastName, gender, age, birth, email, password, type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildAvater(),
              buildCamera(),
              buildName(),
              buildLastName(),
              buildGender(),
              buildAge(),
              buildBirth(),
              buildEmail(),
              buildPassword(),
              buildType(),
              buildRaisedButton()
            ],
          ),
        ),
      ),
    );
  }

  Container buildRaisedButton() => Container(
        width: MediaQuery.of(context).size.width,
        child: RaisedButton.icon(
            color: Colors.deepOrange,
            onPressed: () {
              if (file == null) {
                normalDialod(context, 'Please chose image');
              } else if (name == null ||
                  name.isEmpty ||
                  lastName == null ||
                  lastName.isEmpty ||
                  gender == null ||
                  gender.isEmpty ||
                  age == null ||
                  age.isEmpty ||
                  birth == null ||
                  birth.isEmpty ||
                  email == null ||
                  email.isEmpty ||
                  password == null ||
                  password.isEmpty ||
                  type == null ||
                  type.isEmpty) {
                normalDialod(context, 'Have space ? Please Fill Every Blank');
              } else {
                registerThread();
              }
            },
            icon: Icon(
              Icons.cloud_upload,
              color: Colors.purple,
            ),
            label: Text(
              'Register',
              style: TextStyle(color: Colors.yellow),
            )),
      );

  Container buildCamera() {
    return Container(
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () => chooseImage(ImageSource.camera),
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () => chooseImage(ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result.path);
      });
    } catch (e) {}
  }

  Container buildAvater() {
    return Container(
      width: 250,
      height: 250,
      child: file == null ? Image.asset('images/avatar.png') : Image.file(file),
    );
  }

  Container buildName() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextField(
        onChanged: (value) => name = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Name :',
          suffixIcon: Icon(Icons.account_circle),
        ),
      ),
    );
  }

  Container buildLastName() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextField(
        onChanged: (value) => lastName = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'LastName :',
          suffixIcon: Icon(Icons.account_circle),
        ),
      ),
    );
  }

  Container buildGender() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextField(
        onChanged: (value) => gender = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Gender :',
          suffixIcon: Icon(Icons.wc),
        ),
      ),
    );
  }

  Container buildAge() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextField(
        keyboardType: TextInputType.number,
        onChanged: (value) => age = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Age :',
          suffixIcon: Icon(Icons.nature_people),
        ),
      ),
    );
  }

  Container buildBirth() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextField(
        onChanged: (value) => birth = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Birth Day :',
          suffixIcon: Icon(Icons.wb_sunny),
        ),
      ),
    );
  }

  Container buildEmail() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) => email = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'E-mail :',
          suffixIcon: Icon(Icons.alternate_email),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextField(
        onChanged: (value) => password = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password :',
          suffixIcon: Icon(Icons.lock),
        ),
      ),
    );
  }

  Container buildType() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextField(
        onChanged: (value) => type = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Type :',
          suffixIcon: Icon(Icons.description),
        ),
      ),
    );
  }

  Future<Null> registerThread() async {
    await Firebase.initializeApp().then((value) async {
      print('Connected Success');
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        String uid = value.user.uid;
        print('uid ==>> $uid');
        StorageReference reference =
            FirebaseStorage.instance.ref().child('Avartar/$uid.jpg');
        StorageUploadTask task = reference.putFile(file);
        String urlAvatar = await (await task.onComplete).ref.getDownloadURL();
        print('urlAvatar = $urlAvatar');
        Map<String, dynamic> typeData = Map();
        typeData['Type'] = type;
        await FirebaseFirestore.instance
            .collection('Type')
            .doc(uid)
            .set(typeData);

        Map<String, dynamic> userdata = Map();
        userdata['UrlAvatar'] = urlAvatar;
        userdata['Name'] = name;
        userdata['LastName'] = lastName;
        userdata['Gender'] = gender;
        userdata['Age'] = age;
        userdata['Birth'] = birth;
        userdata['Email'] = email;
        userdata['Password'] = password;
        userdata['Type'] = type;

        await FirebaseFirestore.instance
            .collection('User')
            .doc(uid)
            .set(userdata)
            .then((value) => Navigator.pop(context));
      });
    }).catchError((value) {
      normalDialod(context, value.message);
    });
  }
}

// Test
// import 'package:flutter/cupertino.dart';

// class Login extends StatefulWidget {
//   @override
//   _LoginState createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//     );
//   }
// }
