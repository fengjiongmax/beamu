import 'package:flutter/material.dart';

import 'package:beamu/model/organization_model.dart';

class OrganizationDisplay extends StatefulWidget{
  final OrganizationModel org;

  OrganizationDisplay({@required this.org,Key key}):super(key:key);


  @override
  OrganizationDisplayState createState() => new OrganizationDisplayState(org:org);

}

class OrganizationDisplayState extends State<OrganizationDisplay>{
  final OrganizationModel org;

  OrganizationDisplayState({@required this.org}):super();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

}