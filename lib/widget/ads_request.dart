import 'package:flutter/material.dart';
import 'package:tongmoopa/utlity/search_section.dart';
import 'package:tongmoopa/widget/drawer_bar.dart';

class AdsRequest extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Widget formData() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name:'),
            TextFormField(
              controller: nameController,
              validator: (value) {
                String message;
                if (value == null || value.isEmpty) {
                  message = 'ต้องการข้อมูล';
                }
                return message;
              },
              onSaved: (value) => {},
            ),
            Text('Email:'),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              validator: (value) {
                String message;
                if (value == null || value.isEmpty) {
                  message = 'ต้องการข้อมูล';
                }
                return message;
              },
              onSaved: (value) => {},
            ),
            Text('Tel:'),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: telephoneController,
              validator: (value) {
                String message;
                if (value == null || value.isEmpty) {
                  message = 'ต้องการข้อมูล';
                }
                return message;
              },
              onSaved: (value) => {},
            ),
            Text('Message:'),
            TextFormField(
              maxLines: 8,
              keyboardType: TextInputType.multiline,
              controller: messageController,
              validator: (value) {
                String message;
                if (value == null || value.isEmpty) {
                  message = 'ต้องการข้อมูล';
                }
                return message;
              },
              onSaved: (value) => print(value),
            ),
          ],
        ),
      ),
    );
  }

  void validate() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ads Request',
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
            Text(
              'โฆษณากับเรา',
              style: TextStyle(fontSize: 24.0),
            ),
            formData(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 75,
              child: RaisedButton(
                onPressed: () => validate(),
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
