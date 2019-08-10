import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          ListTile(
            leading: Icon(Icons.access_alarm),
            title: Text('Manage Alerts'),
          ),
          ListTile(
            leading: Icon(Icons.add_location),
            title: Text('Set Default Location'),
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text('About'),
          )
        ],
      ),
    );
  }
}