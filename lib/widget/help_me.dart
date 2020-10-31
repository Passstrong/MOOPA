import 'dart:async';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tongmoopa/model/list_item.dart';
import 'package:tongmoopa/utlity/scoped_models/app_model.dart';
import 'package:tongmoopa/utlity/search_section.dart';
import 'package:tongmoopa/widget/drawer_bar.dart';
import 'package:tongmoopa/widget/help_list.dart';

class HelpMe extends StatefulWidget {
  @override
  _HelpMeState createState() => _HelpMeState();
}


class _HelpMeState extends State<HelpMe> {
  TextEditingController emailController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();

  File _image;
  final picker = ImagePicker();

  List<ListItem> _dropdownItems = [
    ListItem(0, "***กรุณาเลือกหมวดหมู่***"),
    ListItem(1, "แจ้งความตำรวจ"),
    ListItem(2, "รถพยาบาล"),
    ListItem(3, "รถดับเพลิง"),
    ListItem(4, "ช่วยชีวิต - ทางน้ำ"),
    ListItem(5, "ช่วยชีวิต - ทางบก"),
    ListItem(6, "มูลนิธิกู้ภัย"),
    ListItem(7, "ขอความช่วยเหลือจากคนใกล้ฉัน (5 Km)"),
    ListItem(8, "เรียกประกันภัย - รถยนต์"),
    ListItem(9, "เรียกประกันภัย - สุขภาพ"),
    ListItem(10, "อื่นๆ"),
  ];

  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;

  final _formKey = GlobalKey<FormState>();

  Completer<GoogleMapController> _controller = Completer();

  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;
  }

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> getLocation() async {
    final user = ScopedModel.of<AppModel>(context, rebuildOnChange: false);
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    user.setLocationLat(_locationData.latitude);
    user.setLocationLong(_locationData.longitude);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(user.latittude, user.longittude),
          zoom: 14.4746,
        ),
      ),
    );
  }

  Widget formData() {
    final user = ScopedModel.of<AppModel>(context, rebuildOnChange: true);
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email:'),
            TextFormField(
              initialValue: user.userEmail,
              // controller: emailController,
              validator: (value) {
                String message;
                if (value == null || value.isEmpty) {
                  message = 'ต้องการข้อมูล';
                }
                return message;
              },
              onSaved: (value) => user.setEmail(
                value.trim(),
              ),
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
              onSaved: (value) => user.setTelephone(value.trim()),
            ),
            Text('Real Pic:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => getImageCamera(),
                  child: Icon(Icons.camera_alt),
                ),
                Container(),
                RaisedButton(
                  onPressed: () => getImageGallery(),
                  child: Icon(Icons.photo),
                )
              ],
            ),
            Center(
              child: Container(
                margin: EdgeInsets.all(5.0),
                color: Colors.white,
                child: _image == null
                    ? Text('No image selected.')
                    : Image.file(_image),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20.0),
              child: DropdownButton<ListItem>(
                hint: Text('***กรุณาเลือกหมวดหมู่***'),
                value: _selectedItem,
                items: _dropdownMenuItems,
                onChanged: (value) {
                  setState(() {
                    _selectedItem = value;
                  });
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 75,
              child: RaisedButton(
                color: Colors.red[300],
                onPressed: () => validate(),
                child: Text('Click Start'),
              ),
            ),
            Container(),
            // Coming Sooon V2.
            Container(
              width: MediaQuery.of(context).size.width,
              height: 75,
              child: RaisedButton(
                color: Colors.yellow[300],
                onPressed: () => {},
                child: Text('Art Of Safety'),
              ),
            ),
            Container(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 75,
              child: RaisedButton(
                color: Colors.green[300],
                onPressed: () => getLocation(),
                child: Text('GPS of me'),
              ),
            ),
            Container(
              height: 300,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(user.latittude, user.longittude),
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: <Marker>[
                  Marker(
                    markerId: MarkerId("marker_1"),
                    position: LatLng(user.latittude, user.longittude),
                  ),
                ].toSet(),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(
            listItem.name,
            style: TextStyle(color: Colors.red),
          ),
          value: listItem,
        ),
      );
    }
    return items;
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
          'Help Me',
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
              'Help Me!',
              style: TextStyle(fontSize: 24.0),
            ),
            formData(),
          ],
        ),
      ),
    );
  }
}
