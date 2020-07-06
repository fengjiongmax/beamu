/*
routes/organization_list.dart
*/

import 'package:flutter/material.dart';

import 'package:beamu/data/organization_data.dart';

import 'package:beamu/components/drawer.dart';

import 'package:beamu/model/organization_model.dart';

import 'package:beamu/share/tmp_store.dart';

class OrganizationList extends StatefulWidget {
  @override
  OrganizationListState createState() => new OrganizationListState();
}

class OrganizationListState extends State<OrganizationList> {
  List<OrganizationModel> _orgs = tmpStorage.orgs;
  bool _orgsLoading = true;

  Widget _buildOrganizationCard(OrganizationModel org) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 18.0 / 11.0,
            child: Image.network(org.avatarUrl),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[Text(org.userName)],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getSelfOrganizations().then((v) {
      if (this.mounted) {
        _orgs = v;
        _orgsLoading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: BeamuDrawer(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Organizations'),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(16.0),
          childAspectRatio: 8.0 / 9.0,
          children: _orgs.map((o) {
            return _buildOrganizationCard(o);
          }).toList(),
        ));
  }
}
