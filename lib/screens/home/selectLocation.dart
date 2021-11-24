import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class selectLocation extends StatefulWidget {
  @override
  _selectLocation createState() => _selectLocation();
}

class _selectLocation extends State<selectLocation> {
  var googleMap=GoogleMap(initialCameraPosition: CameraPosition(target:LatLng(24.708481, 46.752108) ));
  double saveLat = 0;
  double saveLong = 0;
  List<Marker> myMarker = [];
   late GoogleMapController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: GoogleMap(
                            initialCameraPosition:
                                CameraPosition(target: LatLng(24.708481, 46.752108)  , zoom: 5),
                            mapType: MapType.normal,
                            onMapCreated: _onMapCreated,
                            rotateGesturesEnabled: true,
                            scrollGesturesEnabled: true,
                            zoomControlsEnabled: true,
                            zoomGesturesEnabled: true,
                            liteModeEnabled: false,
                            tiltGesturesEnabled: true,
                            myLocationEnabled: true,
                            markers: Set.from(myMarker),
                            onTap: _handleTap,
    ));
                        


  
  }
  void _handleTap(LatLng tappedPoint) {
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          draggable: true,
          onDragEnd: (dragEndPosition) {
            print(dragEndPosition);
          }));
      saveLat = tappedPoint.latitude;
      saveLong = tappedPoint.longitude;
  
                });
  }
  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    
  }
}


 