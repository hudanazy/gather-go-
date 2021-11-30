import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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
  late LatLng aa;
  List<Marker> myMarker = [];
   late GoogleMapController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SecondaryAppBar(title: "Select Event Location",)
      ,

    body: Column(mainAxisSize: MainAxisSize.max,children: [
       Expanded(child: Container(
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
    ),),),
    !selected?Container():Flex(
      direction:Axis.horizontal,
      children: <Widget>[Padding(
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
                          onPressed: (){
                            
                            print("the 777777777777777777777 resssssult is lat : $saveLat , long: $saveLong , fffffff $aa");
                            
  //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>  createEvent(saveLat: saveLat, saveLong: saveLong, )), (Route route) => true);
   Navigator.pop(context,true);
    // Navigator.of(context).pop(
                                            
    //                                         MaterialPageRoute(
    //                                             builder: (context) =>
    //                                                 createEvent(saveLat1: saveLat, saveLong1: saveLong,
                                                      
    //                                                 )));
    //Navigator.popUntil(context, (route) => route.isFirst);

                          
                                                    
                                                    },
     ) )]),],));
                        


  
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
          aa= tappedPoint;
      saveLat = tappedPoint.latitude;
      saveLong = tappedPoint.longitude;
  selected= true;
                });
  }
  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    
  }
}


 