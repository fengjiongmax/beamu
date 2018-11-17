import 'package:flutter/material.dart';

import 'package:beamu/share/authorizations.dart';

import 'package:beamu/routes/login.dart';

class BeamuDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text('BEAMU'),
            decoration: BoxDecoration(
              color: Colors.blue
            ),
          ),
          ListTile(
            leading: Icon(Icons.perm_contact_calendar),
            title: Text('Profile'),
            onTap: (){

            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async{
              await logout();
              Navigator.pushReplacement(context,
               MaterialPageRoute(builder: (BuildContext context) =>Login())
              );
            },
          ),
        ],
      ),
    );
  }
  
}