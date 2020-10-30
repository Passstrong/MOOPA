import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:tongmoopa/utlity/search_section.dart';
import 'package:tongmoopa/widget/drawer_bar.dart';

class AdsRequest extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget formData() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name:' , style: TextStyle(color: Colors.yellow),),
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
            Text('Email:' , style: TextStyle(color: Colors.yellow),),
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
            Text('Tel:' , style: TextStyle(color: Colors.yellow),),
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
            Text('Message:' , style: TextStyle(color: Colors.yellow),),
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
              onSaved: (value) => {},
            ),
          ],
        ),
      ),
    );
  }

  Future<void> validate() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(messageController.text);
      final Email email = Email(
        subject: nameController.text,
        body:
            '${messageController.text} from ${emailController.text} : ${telephoneController.text}',
        recipients: ['sawasdeepeemai555@gmail.com'],
        isHTML: false,
      );

      String platformResponse;

      try {
        await FlutterEmailSender.send(email);
        platformResponse = 'success';
      } catch (error) {
        platformResponse = error.toString();
      }

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(platformResponse),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
              style: TextStyle(fontSize: 24.0 , color: Colors.yellow),
            ),
            formData(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 75,
              child: RaisedButton(
                onPressed: () => validate(),
                child: Text('Submit' , style: TextStyle(color: Colors.teal[300]),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
