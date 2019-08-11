import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jam_i/createalert.dart';
import 'package:jam_i/side_drawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';


void main() => runApp(App());

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController _controller;
  ScrollController controller = ScrollController();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  CollectionReference incidents = Firestore.instance.collection('/incidents');
  String token;

  static const LatLng _center = const LatLng(18, -76.8);

  final Set<Marker> _markers = Set();

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  String searchAddr;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  // void _onAddMarkerButtonPressed() {
  //   setState(() {
  //     _markers.add(Marker(
  //       // This marker id can be anything that uniquely identifies each marker.
  //       markerId: MarkerId(_lastMapPosition.toString()),
  //       position: _lastMapPosition,
  //       infoWindow: InfoWindow(
  //         title: 'Wile Side Govament',
  //         snippet: 'Bare gunman deh yah',
  //       ),
  //       icon: BitmapDescriptor.defaultMarkerWithHue(255),
  //     ));
  //   });
  // }

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
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          isDismissible: true,
          duration: Duration(seconds: 3),
          message: 'A new post was added',
        )..show(context);
      },
      onLaunch: (notification) async{
        print(notification);
      },
      onResume: (notification)async{
        print(notification);
      }
    );  
  }

  void getFCMToken() async{
    token = await firebaseMessaging.getToken();
    await Firestore.instance.collection('tokens').add({'token':token});
  }
  

  void getAlerts() async{
    try{
      if(incidents != null){
      final queries = await incidents.getDocuments();
      queries.documents.forEach((document){setState((){
        _markers.add(Marker(
          markerId: MarkerId(document.toString()),
          position: LatLng(double.parse(document.data['location'].substring(7,12)),double.parse(document.data['location'].substring(26,31))),
          infoWindow: InfoWindow(
          title: document.data['type'],
          snippet: document.data['details'],
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(document.data['markerColor']==null?0.0:double.parse(document.data['markerColor'])),
        ));
      });
      });
    }
    }
    catch(err){
      print(err);
    }
    
  }


  @override
  void initState() {
    super.initState();
    initializeFCM();
    firebaseMessaging.getToken().then((token){
      print(token);
    });
    getFCMToken();
    getAlerts();
  }

  searchandNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then((result) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
              LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 10.0)));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('JAM i'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            //color: Color(0xFF00ADEF),
            icon: Icon(
              Icons.map,
            ),
            onPressed: _onMapTypeButtonPressed,
          ),
          // IconButton(
          //   //color: Color(0xFF00ADEF),
          //   icon: Icon(
          //     Icons.add_location,
          //   ),
          //   onPressed: _onAddMarkerButtonPressed,
          // ),
          PopupMenuButton(
            icon: Icon(Icons.arrow_drop_down),
            itemBuilder: (context) {
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
                        Text('Abduction')
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
                        Text('Assault')
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
                      Icon(Icons.warning),
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
      body: 
      Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child:GoogleMap(
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
            Positioned(
          top: 30.0,
          right: 15.0,
          left: 15.0,
          child: Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), color: Colors.black26),
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Enter Address',
                  hintStyle: TextStyle(color: Colors.black87),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                  suffixIcon: IconButton(
                      icon: Icon(Icons.search, color: Colors.black87),
                      onPressed: searchandNavigate,
                      iconSize: 30.0)),
              onChanged: (val) {
                setState(() {
                  searchAddr = val;
                });
              },
            ),
          ),
        ),



            Positioned(
              top: 80,
              right: 10,
              child: FlatButton(
                child: Icon(
                  Icons.person_pin,
                  size: 40,
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
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  shape: StadiumBorder(),
                  color: Colors.deepOrange,
                  child: Text('Report'),
                  onPressed: () async {
                    try{
                      var data = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) { return UserInfo(userinfo: null,); })
                      );

                      if(data[3]==null || data[1]==null){
                        return;
                      }
                      
                      setState(() {
                        _markers.add(Marker(
                          // This marker id can be anything that uniquely identifies each marker.
                          markerId: MarkerId(data.toString()),
                          position: data[3],
                          infoWindow: InfoWindow(
                            title: data[1],
                            snippet: data[0],
                          ),
                          icon: data[1]=='Murder'? 
                          BitmapDescriptor.defaultMarkerWithHue(0)
                          : data[1]=='Gang Violence'?
                          BitmapDescriptor.defaultMarkerWithHue(43)
                          : data[1]=='Road Accident' ?
                          BitmapDescriptor.defaultMarkerWithHue(86)
                          :data[1]=='Larceny' ?
                          BitmapDescriptor.defaultMarkerWithHue(129) 
                          : data[1]=='Abduction' ?
                          BitmapDescriptor.defaultMarkerWithHue(172)
                          : BitmapDescriptor.defaultMarkerWithHue(215)
                        ));
                      });
                      await incidents.add({
                        'token':token,
                        'location':data[3].toString(),
                        'type':data[1],
                        'details':data[0],
                        'highthreatlevel': data[2],
                        'createdBy':token,
                        'markerColor': data[1]=='Murder'? 
                          0
                          : data[1]=='Gang Violence'?
                          43
                          : data[1]=='Road Accident' ?
                          86
                          :data[1]=='Larceny' ?
                          129 
                          : data[1]=='Abduction' ?
                          172
                          :215
                      });
                    }
                    catch(err){
                      print(err);
                      Flushbar(
                        flushbarPosition: FlushbarPosition.BOTTOM,
                        duration: Duration(seconds: 3),
                        message: 'Failed. Try again',
                        isDismissible: true,
                      )..show(context);
                    }
                  }
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
