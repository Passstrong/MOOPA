import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';
import 'package:tongmoopa/widget/sos_detail.dart';
import 'package:flutter/widgets.dart';
import 'package:tongmoopa/utlity/scoped_models/app_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tongmoopa/utlity/my_style.dart';
import 'package:location/location.dart';

class MainSOS extends StatefulWidget {
  @override
  _MainSOSState createState() => _MainSOSState();
}

class _MainSOSState extends State<MainSOS> {
  
  AppModel user;
  Timer timer;
  List<QueryDocumentSnapshot> list;
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    user = ScopedModel.of<AppModel>(context, rebuildOnChange: false);
    getLocation();
    checkHelpMeList();
    timer =
        Timer.periodic(Duration(seconds: 5), (Timer t) => checkHelpMeList());
        // Future.delayed(Duration(milliseconds: 0), () async {
        //if (list != null && list.isNotEmpty) {
        //     final GoogleMapController controller = await _controller.future;
        //     controller.animateCamera(
    //       CameraUpdate.newCameraPosition(
    //         CameraPosition(
    //           target: LatLng(list['Latittude'], list['Longittude']),
    //           // zoom: 14.4746,
    //           zoom: 19,
    //         ),
    //       ),
    //     );
    //   }
    // });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkHelpMeList() async {
    await FirebaseFirestore.instance
        .collection('HelpME')
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        setState(() {
          list = querySnapshot.docs;
        });
        print(list[0].data()['Email']);
      } else {
        setState(() {
          list = null;
        });
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
          // zoom: 14.4746,
          zoom: 19,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ScopedModel.of<AppModel>(context, rebuildOnChange: false);
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
                  subtitle: Text('status: ' +
                      (data['Status'] == 0
                          ? 'งานใหม่'
                          : (data['Status'] == 1 ? 'รับงานแล้ว' : 'ERR.')) +
                      '\n' +
                      '${data['Latitude']}   ${data['Longittude']}'),
                  isThreeLine: true,
                  onTap: () async {
                    Map<String, dynamic> userdata = Map();
                    userdata['HelperLat'] = user.latittude;
                    userdata['HelperLong'] = user.longittude;
                    userdata['Status'] = 1;
                    print('helperdata $userdata');
                    await FirebaseFirestore.instance
                        .collection('HelpME')
                        .doc(data['Email'])
                        .update(userdata)
                        .then((value) {
                      Toast.show('รับงานเรียบร้อยแล้ว', context);
                      checkHelpMeList();
                    });
                  },
                );
              })
          : Text('no LIST'),
    );
  }
}
