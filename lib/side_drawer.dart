import 'package:flutter/material.dart';

class SideDrawer extends StatefulWidget {

  SideDrawerState createState() => SideDrawerState();
}

class SideDrawerState extends State<SideDrawer> {
bool livealert = false;
String searchAddr = "";
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Options'),
          ),
          ListTile(
            leading: Icon(Icons.access_alarm),
            title: Text('Live Alerts'),
            trailing: Switch(
                  value: livealert,
                  onChanged: (value) {
                    setState(() {
                      livealert = value;
                    });
                  }),
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text('About'),
          ),
        ],
      ),
    );
  }
}