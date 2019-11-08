import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Parking extends StatelessWidget {

  static const String _title = 'Parking';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: ParkingState(),
    );
  }
}

class ParkingState extends StatefulWidget {
  ParkingState({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}


class _MyStatefulWidgetState extends State<ParkingState> {

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  Completer<GoogleMapController> _controller = Completer();


void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Maps in Flutter'),
          centerTitle: true,
        ),
      body: new Center(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              child: GoogleMap(  
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: _onMapCreated,
            ),
            ),
          ],
        ),
      ),
    );
  }
}