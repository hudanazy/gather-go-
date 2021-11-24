import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../myAppBar.dart';
import 'createEvent.dart';

class selectLocation extends StatefulWidget {
  @override
  _selectLocation createState() => _selectLocation();
}

class _selectLocation extends State<selectLocation> {
  bool selected=false;
  var googleMap=GoogleMap(initialCameraPosition: CameraPosition(target:LatLng(24.708481, 46.752108) ));
  double saveLat = 0;
  double saveLong = 0;
  List<Marker> myMarker = [];
   late GoogleMapController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SecondaryAppBar(title: "Select Event Location",)
      ,

    body: Column(mainAxisSize: MainAxisSize.max,children: [
       Container(
                     height: 450,
   child: GoogleMap(
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
    ),),
    !selected?Container():Padding(
                                padding: const EdgeInsets.all(8),
                                child:ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.orange[400]),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.fromLTRB(35, 15, 35, 15))),
                          child: Text(
                            'Ok',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Comfortaa"),
                          ),
                          onPressed: (){Navigator.pop(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    createEvent(saveLat: saveLat, saveLong: saveLong,
                                                      
                                                    )));},
     ) )],));
                        


  
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
  selected= true;
                });
  }
  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    
  }
}


 