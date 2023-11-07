import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  bool showmap = false;

  void initstate() {
    super.initState();
    showmapfunc();
    _loadMapStyles();
  }

  var mapthemdata;
  Future _loadMapStyles() async {
    mapthemdata = await rootBundle.loadString('asset/raw/maptheme.json');
  }

  showmapfunc() {
    Future.delayed(Duration(seconds: 1)).whenComplete(() {
      setState(() {
        showmap = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          showmap
              ? GoogleMap(
                  // mapType: MapType.hybrid,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    controller.setMapStyle(mapthemdata);
                    _controller.complete(controller);
                  },
                )
              : Container(child: Center(child: CircularProgressIndicator())),
          Positioned(
            top: 20,
            left: 0,
            child: Container(
              padding: EdgeInsets.all(15),
              height: 60,
              width: size.width,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
