import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tongmoopa/utlity/scoped_models/app_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HelpMeList extends StatefulWidget {
  final String userEmail;

  HelpMeList({this.userEmail});
  @override
  _HelpMeListState createState() => _HelpMeListState();
}

class _HelpMeListState extends State<HelpMeList> {
  AppModel user;
  Timer timer;
  Map<String, dynamic> list;
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    getLocation();
    checkHelpMeList(widget.userEmail);
    timer = Timer.periodic(
      Duration(seconds: 5),
      (Timer t) => checkHelpMeList(widget.userEmail),
    );
    Future.delayed(Duration(milliseconds: 0), () async {
      if (list != null && list.isNotEmpty) {
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                list['Latittude'],
                list['Longittude'],
              ),
              zoom: 19,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
          target: LatLng(
            user.latittude,
            user.longittude,
          ),
          zoom: 19,
        ),
      ),
    );
  }

  Future checkHelpMeList(String email) async {
    FirebaseFirestore.instance
        .collection('HelpME')
        .doc(email)
        .snapshots()
        .listen((event) {
      print(
          'event : ${event.data()['Email']}, status:${event.data()['Status']}');
      print(
          'location : ${event.data()['Latitude']}  ${event.data()['Longittude']}');
      print(
          'helper : ${event.data()['HelperLat']}  ${event.data()['HelperLong']}');

      if (event.exists) {
        var data = event.data();
        if (data['Status'] < 9) {
          setState(() {
            list = event.data();
          });
        } else {
          setState(() {
            list = null;
          });
        }
      } else {
        setState(() {
          list = null;
        });
      }
    });
  }

  Future updateStatus(int status) async {
    FirebaseFirestore.instance
        .collection('HelpME')
        .doc(widget.userEmail)
        .update({'Status': status});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = ScopedModel.of<AppModel>(context, rebuildOnChange: false);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: (list != null && list.isNotEmpty)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'มีการแจ้ง',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Group: ${list['GroupName'] ?? ''}',
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Email: ${list['Email']}',
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Tel: ${list['Tel']}',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 300,
                      padding: EdgeInsets.all(10),
                      child: Image.network(
                        list['UrlAvatar'],
                        scale: 0.5,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'lat:${list['Latitude']} lng:${list['Longittude']}\n' +
                                'สถานะ : ' +
                                (list['Status'] == 0
                                    ? 'งานใหม่'
                                    : (list['Status'] == 1
                                        ? 'รับงานแล้ว'
                                        : 'ปฎิเสธ.')),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlatButton(
                            onPressed: () async {
                              await updateStatus(1);
                            },
                            child: Container(
                              height: 50,
                              color: Colors.blue,
                              child: Center(
                                child: Text(
                                  'รับงาน',
                                ),
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () async {
                              await updateStatus(2);
                            },
                            child: Container(
                              height: 50,
                              color: Colors.red,
                              child: Center(
                                child: Text(
                                  'ปฏิเสธรับงาน',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 600,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(list['Latitude'], list['Longittude']),
                          zoom: 15,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        markers: <Marker>[
                          Marker(
                            markerId: MarkerId("marker_user"),
                            position: LatLng(
                              list['Latitude'],
                              list['Longittude'],
                            ),
                          ),
                          Marker(
                            markerId: MarkerId("marker_helper"),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueBlue,
                            ),
                            position: LatLng(
                              user.latittude,
                              user.longittude,
                            ),
                          )
                        ].toSet(),
                      ),
                    ),
                  ],
                )
              : Center(child: Text('ไม่มึงานในตอนนี้')),
        ),
      ),
    );
  }
}
