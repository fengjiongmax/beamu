import 'package:flutter/material.dart';

import 'package:beamu/model/repository_model.dart';
import 'package:beamu/data/repository_data.dart';

class Repositories extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new RepositoriesState();
}

class RepositoriesState extends State<Repositories>{
  var _repoLists = new List<RepositoryModel>(); 
  var loading = true;
  
  Widget _buildRepos(){
    if(_repoLists.isEmpty || _repoLists.length == 0){
      return Center(
        child: Text('No Repo Found'),
      );
    }
    return Column(
      children: _repoLists.map((repo){
        return ListTile(
          title: Text(repo.id.toString()),
          onTap: (){
            print(repo.id);
          },
        );
      }).toList()
    );
  }

  Widget _buildRepo(RepositoryModel repo){
    return ListTile(
      title: Text(repo.id.toString()),
      onTap: (){
        print(repo.id);
      },
    );
  }

  @override
  void initState(){
    super.initState();
    getSelfRepositories().then((v){
      print("data got");
      setState(() {
              _repoLists.addAll(v);
              loading=false;
            });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Repositories'),),
      body: loading?Center(child: Text('Fetching you repos...'),): _buildRepos()
    );
  }
}