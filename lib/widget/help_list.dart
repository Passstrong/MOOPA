import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tongmoopa/utlity/scoped_models/app_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HelpMeList extends StatefulWidget {
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
    user = ScopedModel.of<AppModel>(context, rebuildOnChange: false);
    checkHelpMeList();
    timer =
        Timer.periodic(Duration(seconds: 5), (Timer t) => checkHelpMeList());
    Future.delayed(Duration(milliseconds: 0), () async {
      if (list != null && list.isNotEmpty) {
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(list['Latittude'], list['Longittude']),
              // zoom: 14.4746,
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

  Future checkHelpMeList() async {
    FirebaseFirestore.instance
        .collection('HelpME')
        .doc(user.userEmail)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: (list != null && list.isNotEmpty)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'มีการแจ้ง\n' +
                        'lat:${list['Latitude']} lng:${list['Longittude']}\n' +
                        'สถานะ : ' +
                        (list['Status'] == 0
                            ? 'งานใหม่'
                            : (list['Status'] == 1 ? 'รับงานแล้ว' : 'ERR.')),
                    textAlign: TextAlign.center,
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
                          markerId: MarkerId("marker_1"),
                          position:
                              LatLng(list['Latitude'], list['Longittude']),
                        ),
                        (list['HelperLat'] != null && list['HelperLong'] != null
                            ? Marker(
                                markerId: MarkerId("marker_2"),
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueBlue),
                                position: LatLng(
                                    list['HelperLat'], list['HelperLong']),
                              )
                            : Marker(
                                markerId: MarkerId("marker_2"),
                                position: LatLng(1, 1),
                              )),
                      ].toSet(),
                    ),
                  ),
                ],
              )
            : Text('no LIST'),
      ),
    );
  }
}
