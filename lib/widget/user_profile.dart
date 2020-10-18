import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tongmoopa/utlity/normal_dialog.dart';
import 'package:tongmoopa/utlity/scoped_models/app_model.dart';
import 'package:tongmoopa/utlity/search_section.dart';
import 'package:tongmoopa/widget/drawer_bar.dart';

class UserProfile extends StatefulWidget {
    @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  File file;
  
  String urlAvatar, name, lastName, gender, age, birth, email, password, type;


  @override
  Widget build(BuildContext context) {

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
            'Update Profile',
            style: TextStyle(color: Colors.yellow),
          ),
        ),
      );

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

  Container buildCamera() {
    return Container(
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.add_a_photo, color: Colors.yellow,),
            onPressed: () => chooseImage(ImageSource.camera),
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate, color: Colors.yellow,),
            onPressed: () => chooseImage(ImageSource.gallery),
          ),
        ],
      ),
    );
  }



  Container buildAvater() {
    final user = ScopedModel.of<AppModel>(context, rebuildOnChange: true);
    return Container(
      width: 250,
      height: 250,
      child: file == null ? Image.network(user.imageProfile) : Image.file(file),
    );
  }

  Container buildName() {
    final user = ScopedModel.of<AppModel>(context, rebuildOnChange: true);
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextFormField(
        initialValue: user.username,
        onChanged: (value) => name = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Name :',
          suffixIcon: Icon(Icons.account_circle,color: Colors.yellow,),
        ),
      ),
    );
  }

  Container buildLastName() {
    final user = ScopedModel.of<AppModel>(context, rebuildOnChange: true);
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextFormField(
        initialValue: user.userLastname,
        onChanged: (value) => lastName = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'LastName :',
          suffixIcon: Icon(Icons.account_circle, color: Colors.yellow,),
        ),
      ),
    );
  }

  Container buildGender() {
    final user = ScopedModel.of<AppModel>(context, rebuildOnChange: true);
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextFormField(
        initialValue: user.userGender,
        onChanged: (value) => gender = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Gender :',
          suffixIcon: Icon(Icons.wc, color: Colors.yellow,),
        ),
      ),
    );
  }

  Container buildAge() {
    final user = ScopedModel.of<AppModel>(context, rebuildOnChange: true);
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextFormField(
        initialValue: user.userAge,
        keyboardType: TextInputType.number,
        onChanged: (value) => age = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Age :',
          suffixIcon: Icon(Icons.nature_people, color: Colors.yellow,),
        ),
      ),
    );
  }

  Container buildBirth() {
    final user = ScopedModel.of<AppModel>(context, rebuildOnChange: true);
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextFormField(
        initialValue: user.dateOfBirth,
        onChanged: (value) => birth = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Birth Day :',
          suffixIcon: Icon(Icons.wb_sunny, color: Colors.yellow,),
        ),
      ),
    );
  }

  Container buildEmail() {
    final user = ScopedModel.of<AppModel>(context, rebuildOnChange: true);
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextFormField(
        initialValue: user.userEmail,
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) => email = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'E-mail :',
          suffixIcon: Icon(Icons.alternate_email, color: Colors.yellow,),
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
          suffixIcon: Icon(Icons.lock, color: Colors.yellow,),
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
          suffixIcon: Icon(Icons.description, color: Colors.yellow,),
        ),
      ),
    );
  }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: TextStyle(color: Colors.pink[100]),
        ),
        backgroundColor: Colors.blue[900],
      ),
      backgroundColor: Colors.blue.shade900,
      drawer: DrawerBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SearchHome(),
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
            buildRaisedButton(),
          ],
        ),
      ),
    );
  }
}
