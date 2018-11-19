import 'package:flutter/material.dart';

import 'package:beamu/share/authorizations.dart';
import 'package:beamu/share/configs.dart';

import 'package:beamu/routes/login.dart';
import 'package:beamu/routes/organization_list.dart';
import 'package:beamu/routes/repositories_list.dart';

class BeamuDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                SizedBox(height: 80,),
                ListTile(
                  leading: Image.network(config.avatar,height: 50,width: 50,fit: BoxFit.scaleDown,),
                  title: Text(config.userName),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blue
            ),
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Repositories'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(context,
               MaterialPageRoute(builder: (BuildContext context) =>RepositoriesList())
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Organizations'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(context,
               MaterialPageRoute(builder: (BuildContext context) =>OrganizationList())
              );
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.announcement),
          //   title: Text('Assigned issues'),
          //   onTap: (){

          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.perm_contact_calendar),
          //   title: Text('Profile'),
          //   onTap: (){

          //   },
          // ),
          Divider(color: Colors.black,),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async{
              await logout();
              Navigator.of(context).pop();
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