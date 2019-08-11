import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class UserInfo extends StatefulWidget {
  final Map userinfo;
  UserInfo({@required this.userinfo});
  UserInfoState createState() => UserInfoState(userinfo: userinfo);
}

class UserInfoState extends State<UserInfo> {
  final Map userinfo;
  String type;
  bool threatlevel = false;
  UserInfoState({@required this.userinfo});

  GoogleMapController _controller;
  ScrollController controller = ScrollController();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  final Set<Marker> _markers = Set();

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
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
              child: DropdownButton(
                hint: Text(
                  "Please select an Alert Type!",
                ),
                items: [
                  DropdownMenuItem(
                    value: 0,
                    child: Text(
                      "Abduction",
                    ),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text(
                      "Assault",
                    ),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text(
                      "Murder",
                    ),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text(
                      "Larceny",
                    ),
                  ),
                  DropdownMenuItem(
                    value: 4,
                    child: Text(
                      "Gang Violence",
                    ),
                  ),
                  DropdownMenuItem(
                    value: 5,
                    child: Text(
                      "Road Accident",
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    type = value;
                  });
                },
                value: type,
                elevation: 4,
                style: TextStyle( fontSize: 15),
                isDense: true,
                iconSize: 40.0,
              ),
            ),
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
                setState(() {});
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.0),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 0.5, color: Colors.white),
                  right: BorderSide(width: 0.5, color: Colors.white),
                  bottom: BorderSide(width: 0.5, color: Colors.white),
                  left: BorderSide(width: 0.5, color: Colors.white)
                )
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                Text(
                  "  High Threat Level",
                ),
                SizedBox(width: width*.3,),
                Switch(
                    value: threatlevel,
                    onChanged: (value) {
                      setState(() {
                        threatlevel = value;
                      });
                    })
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
