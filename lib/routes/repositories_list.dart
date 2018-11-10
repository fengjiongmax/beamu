import 'package:flutter/material.dart';

import 'package:beamu/model/repository_model.dart';
import 'package:beamu/model/organization_model.dart';

import 'package:beamu/data/repository_data.dart';
import 'package:beamu/data/organization_data.dart';
import 'package:beamu/share/configs.dart';

import 'package:beamu/components/repo_list.dart';

class RepositoriesList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new RepositoriesListState();
}

class RepositoriesListState extends State<RepositoriesList>{
  var _reposList = new List<RepositoryModel>(); 
  var _orgsList = new List<OrganizationModel>();

  var _repoLoading = true;
  var _orgLoading = true;
  var _displayUserName = config.userName;


    TextStyle _ddlStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black
    );

  List<DropdownMenuItem> _buildDDLItems(){
    var _ddlItems = new List<DropdownMenuItem>();

    _ddlItems.add(DropdownMenuItem(child:Text(config.userName,),value: config.userName,));
    if(_orgLoading){
      _ddlItems.add(DropdownMenuItem(child:Text('fetching organizatin info...', style: TextStyle(color:Colors.grey),),value: null,));
    }

    if(_orgsList.isNotEmpty && _orgsList.length>0){
      _ddlItems.addAll(_orgsList.map(
        (o){
          return new DropdownMenuItem(
            child: Text(o.userName),
            value: o.userName,
          );
        }
      ).toList());
    }

    return _ddlItems;
  }

  @override
  void initState(){
    super.initState();
    getSelfRepositories().then((v){
      setState(() {
              _reposList.addAll(v);
              _repoLoading = false;
            });
    });
    getSelfOrganizations().then((v){
      setState(() {
              _orgsList.addAll(v);
              _orgLoading = false;
            });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton(
          items: _buildDDLItems(),
          value: _displayUserName,
          style: _ddlStyle,
          onChanged: (v){
            if(v != null){
              setState(() {
                            _displayUserName=v;
                          });
              }
          },
        )
      ),
      body: _repoLoading?Center(child: Text('Fetching repos...'),): buildReposList(context,_reposList,_displayUserName)
    );
  }
}