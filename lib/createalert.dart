import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class UserInfo extends StatefulWidget {
  final Map userinfo;
  UserInfo({@required this.userinfo});
 UserInfoState createState() => UserInfoState(userinfo: userinfo);
}

class UserInfoState extends State<UserInfo> {
  final Map userinfo;
  UserInfoState({@required this.userinfo});

 Completer<GoogleMapController> _controller = Completer();
  ScrollController controller = ScrollController();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    var height =  MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color,
          title: Text(
        'Profile',
        style: TextStyle( fontSize: 20.0),
      )),
      body: Column(
        children: <Widget>[
          Container(
            height: height*.4,
            child:
                    GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(18, -76.8),
                  zoom: 11.0,
                ),
                mapType: _currentMapType,
                markers: _markers,
                onCameraMove: _onCameraMove,
              ),
          ),
SizedBox(height: 10,),
 TextField(
              autocorrect: true,
              decoration: InputDecoration(
                  labelText: "Title...",
                  contentPadding: EdgeInsets.all(14.0),
                  border: OutlineInputBorder()),
              onChanged: (string) {
                setState(() {
                });
              },

            
          ),
        ],
      ),
    );
  }
}