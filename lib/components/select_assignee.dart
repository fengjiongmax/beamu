import 'package:flutter/material.dart';

import 'package:beamu/model/user_model.dart';

class AssigneeSelector extends StatefulWidget{
  final List<UserModel> collaborators;
  final List<UserModel> assignees;

  AssigneeSelector({this.collaborators,this.assignees,Key key}):super(key:key);

  @override
  _AssigneesSelectorState createState() => _AssigneesSelectorState();
}

class _AssigneesSelectorState extends State<AssigneeSelector>{
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

}

