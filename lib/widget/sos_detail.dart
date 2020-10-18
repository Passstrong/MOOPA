import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tongmoopa/utlity/my_style.dart';

class SOSDetail extends StatelessWidget {
  final Completer<GoogleMapController> _controller = Completer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request'),
      ),
      backgroundColor: Colors.brown,
      drawer: Drawer(
        child: MyStyle().mySignOut(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 300,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(0.0, 0.0),
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: <Marker>[
                  Marker(
                    markerId: MarkerId("marker_1"),
                    position: LatLng(0.0, 0.0),
                  ),
                ].toSet(),
              ),
            ),
            Container(
              child: Image.network(''),
            ),
            Container(
              child: Text('Email: ', style: TextStyle(color: Colors.yellow),),
            ),
             Container(
              child: Text('Tel: ', style: TextStyle(color: Colors.yellow),),
            )
          ],
        ),
      ),
    );
  }
}
