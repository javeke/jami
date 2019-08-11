import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jam_i/date_time.dart';

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

  Map defaultstrs = {
                'Abduction' :'somebody got stolen',
                'Assault': 'sombody got assaulted',
                'Murder': 'persons were shot to death',
                'Larceny': 'property was burned to the ground',
                'Gang Voilence': 'guys fighting over who knows what',
                'Road Issues':'trafic backed up in this area',
  };

  LatLng location;

  bool threatlevel = false;
  UserInfoState({@required this.userinfo});

  GoogleMapController _controller;
  ScrollController controller = ScrollController();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  Set<Marker> _marker = Set();

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

  void _onlocationPressed(LatLng selected) {
    setState(() {
      _marker = {
        Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(_lastMapPosition.toString()),
          position: selected,
          infoWindow: InfoWindow(
            title: 'Really cool place',
            snippet: '5 Star Rating',
          ),
          icon: BitmapDescriptor.defaultMarker,
        )
      };
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void senddata() {
    if(location==null){
      Flushbar(
        backgroundColor: Colors.deepOrange,
        isDismissible: true,
        duration: Duration(seconds: 3),
        messageText: Text('No location was selected'),
      )..show(context);
      return;
    }
    else if(type==null){
      Flushbar(
        backgroundColor: Colors.deepOrange,
        isDismissible: true,
        duration: Duration(seconds: 3),
        messageText: Text('Please select incident type'),
      )..show(context);
      return;
    }
    else if(details==null){
      Flushbar(
        backgroundColor: Colors.deepOrange,
        isDismissible: true,
        duration: Duration(seconds: 3),
        messageText: Text('Please add some incident details'),
      )..show(context);
      return;
    }
    List alertdata = [details, type, threatlevel, location];
    if (details == '' && type != ''){
      details = defaultstrs[type];
    };
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
          title: Text(
            'New Alert',
            style: TextStyle(fontSize: 20.0),
          )),
      body: ListView(
        children: <Widget>[
          Container(
            height: height * .4,
            child: GoogleMap(
              onTap: (tapped) {
                location = tapped;
                _onlocationPressed(tapped);
              },
              myLocationButtonEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(18, -76.8),
                zoom: 11.0,
              ),
              mapType: _currentMapType,
              markers: _marker,
              onCameraMove: _onCameraMove,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.0),
            child: Card(
                child: DropdownButton<String>(
              hint: Text(displaytext),
              items: <String>[
                'Abduction',
                'Assault',
                'Murder',
                'Larceny',
                'Gang Voilence',
                'Road Issues'
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
                  labelStyle: TextStyle(
                    color: Colors.white
                  ),
                  contentPadding: EdgeInsets.all(14.0),
                  border: OutlineInputBorder()),
              onChanged: (string) {
                setState(() {
                  details = string;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.0),
            child: ListTile(leading:
              Text( "High Threat Level"),
              trailing: Switch(
                  value: threatlevel,
                  onChanged: (value) {
                    setState(() {
                      threatlevel = value;
                    });
                  })
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.0),
            child: new Column( 
              children: <Widget>[
                Text( "Select Relevant Date and Time", ),
                new Container(child: new DateAndTime())
              ]
            ) 
          ) 
        ],
      ),
    );
  }
}
