import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jam_i/side_drawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:location/location.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController _controller;
  ScrollController controller = ScrollController();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  // Location location = Location();

  static const LatLng _center = const LatLng(18, -76.8);

  final Set<Marker> _markers = Set();

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
          title: 'Wile Side Govament',
          snippet: 'Bare gunman deh yah',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(255),
        onTap: (){
          
        }
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _animateToPosition() async{
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(_center.latitude, _center.longitude),
        zoom: 18
      )
    ));
  }

  
  void initializeFCM()async{
    firebaseMessaging.configure(
      onMessage: (message)async{
        print(message);
      },
      onLaunch: (notification) async{
        print(notification);
      },
      onResume: (notification)async{
        print(notification);
      }
    );  
  }

  @override
  void initState() {
    super.initState();
    initializeFCM();
    firebaseMessaging.getToken().then((token){
      print(token);
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        drawer: SideDrawer(),
        appBar: AppBar(
          title: Text('JAMi'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.map,),
              onPressed: _onMapTypeButtonPressed,
            ),
            IconButton(
              icon: Icon(Icons.add_location,),
              onPressed: _onAddMarkerButtonPressed,
            ),
            PopupMenuButton(
              icon: Icon(Icons.arrow_drop_down),
              itemBuilder: (context){
                return [
                  PopupMenuItem(
                    value: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.all_inclusive),
                        SizedBox(width: 8,),
                         Text('View All Incidents')
                      ],
                    )
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.person_pin_circle),
                        SizedBox(width: 8,),
                         Text('Missing Persons')
                      ],
                    )
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.accessible_forward),
                        SizedBox(width: 8,),
                         Text('Rape')
                      ],
                    )
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.accessibility_new),
                        SizedBox(width: 8,),
                         Text('Murder')
                      ],
                    )
                  ),
                  PopupMenuItem(
                    value: 4,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.tag_faces),
                        SizedBox(width: 8,),
                         Text('Larceny')
                      ],
                    )
                  ),
                  PopupMenuItem(
                    value: 5,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.gavel),
                        SizedBox(width: 8,),
                         Text('Gang Violence')
                      ],
                    )
                  ),
                  PopupMenuItem(
                    value: 6,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.local_car_wash),
                        SizedBox(width: 8,),
                         Text('Road Accident')
                      ],
                    )
                  )
                ];
              },
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(18, -76.8),
                  zoom: 11.0,
                ),
                mapType: _currentMapType,
                markers: _markers,
                onCameraMove: _onCameraMove,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: FlatButton(
                child: Icon(
                  Icons.person_pin,
                  color: Colors.deepOrange,
                ),
                onPressed: _animateToPosition,
              ),
            ),
            Positioned(
              bottom: 10,
              left: 5,
              right: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FlatButton(
                    padding: EdgeInsets.symmetric(
                      horizontal: 50
                    ),
                    color: Colors.deepPurple,
                    shape: StadiumBorder(),
                    child: Text('Recent'),
                    onPressed: (){},
                  ),
                  SizedBox(width: 20,),
                  FlatButton(
                    padding: EdgeInsets.symmetric(
                      horizontal: 50
                    ),
                    shape: StadiumBorder(),
                    color: Colors.deepOrange,
                    child: Text('Report'),
                    onPressed: (){},
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
