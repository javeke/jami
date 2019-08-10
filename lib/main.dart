import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      darkTheme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
      home: Scaffold(
        drawer: Drawer(),
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
                    child: Text('yow'),
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
              ),
            ),
            // Positioned(
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Align(
            //       alignment: Alignment.topRight,
            //       child: Column(
            //         children: <Widget> [
            //           FloatingActionButton(
            //             onPressed: _onMapTypeButtonPressed,
            //             materialTapTargetSize: MaterialTapTargetSize.padded,
            //             backgroundColor: Colors.green,
            //             child: const Icon(Icons.map, size: 36.0),
            //           ),
            //           SizedBox(height: 16.0),
            //           FloatingActionButton(
            //             onPressed: _onAddMarkerButtonPressed,
            //             materialTapTargetSize: MaterialTapTargetSize.padded,
            //             backgroundColor: Colors.green,
            //             child: const Icon(Icons.add_location, size: 36.0),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
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