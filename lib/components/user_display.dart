/*
components/user_display.dart
*/

import 'package:flutter/material.dart';

import 'package:beamu/model/user_model.dart';

class UserSuqareCard extends StatelessWidget{
  final UserModel user;

  UserSuqareCard({this.user,Key key}):assert(user != null), super(key:key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 18.0/11.0,
            child: Image.network(user.avatarUrl),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(user.username)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class UserListCard extends StatelessWidget{
  final UserModel user;

  UserListCard({this.user,Key key}):assert(user != null), super(key:key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(user.avatarUrl),
        title: Text(user.username),
      ),
    );
  }
}



