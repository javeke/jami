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
  String displaytext = "Alert Type";
  String details = "";
  String type = "";
  var location;
  bool threatlevel = false;
  UserInfoState({@required this.userinfo});

  GoogleMapController _controller;
  //Completer<GoogleMapController> _controller = Completer();
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

  void _animateToPosition() async {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_center.latitude, _center.longitude), zoom: 18)));
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
    _controller = controller;
  }

  void senddata() {
    List alertdata = [details, type, threatlevel, location];
    Navigator.pop(context, alertdata);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                senddata();
              },
            )
          ],
          backgroundColor: Color(0xFF00ADEF),
          title: Text(
            'New Alert',
            style: TextStyle(fontSize: 20.0),
          )),
      body: ListView(
        children: <Widget>[
          Container(
            height: height * .4,
            child: GoogleMap(
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
          Padding(
            padding: EdgeInsets.all(14.0),
            child: Card(
                child: DropdownButton<String>(
              hint: Text(displaytext),
              items: <String>[
                '    Missing Persons',
                '    Rape',
                '    Murder',
                '    Larceny',
                '    Gang Voilence',
                '    Road Accident'
              ].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (_) {
                setState(() {
                displaytext = _;  
                });
                
                type = _;
              },
            )),
          ),
          Padding(
            padding: EdgeInsets.all(14.0),
            child: TextField(
              autocorrect: true,
              maxLines: 4,
              decoration: InputDecoration(
                  labelText: "Details...",
                  contentPadding: EdgeInsets.all(14.0),
                  border: OutlineInputBorder()),
              onChanged: (string) {
                setState(() {});
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.0),
            child: Row(children: [
              Text(
                "  High Threat Level",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              SizedBox(
                width: width * .35,
              ),
              Switch(
                  value: threatlevel,
                  onChanged: (value) {
                    setState(() {
                      threatlevel = value;
                    });
                  })
            ]),
          ),
        ],
      ),
    );
  }
}
