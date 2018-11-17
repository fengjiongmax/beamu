import 'package:flutter/material.dart';

import 'package:beamu/model/repository_model.dart';
import 'package:beamu/share/time_since.dart';

import 'package:beamu/routes/repository.dart';


class RepositoriesListDisplay extends StatelessWidget{
  final List<RepositoryModel> repoList;
  final String userName;

  RepositoriesListDisplay({this.repoList,this.userName,Key key}):super(key:key);

  @override
  Widget build(BuildContext context){
    if(repoList.isEmpty || repoList.length == 0){
      return Center(
        child: Text('0 repository.'),
      );
    }

    final List<RepositoryModel> _renderRepoList = userName.isNotEmpty?  repoList.where((w){return w.owner.username == userName;}).toList()
                                                                      : repoList;

    return ListView(
      children: _renderRepoList.map((repo){
        String updateSince = 'Updated '+ timeSince(repo.updatedAt);
        return Card(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Row(children: <Widget>[
                  Text(
                    repo.name.toString(),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  repo.private?Icon(Icons.lock):Text(""),
                ],),
                subtitle: Text(updateSince),
                trailing: Column(
                  children: <Widget>[
                    Icon(Icons.announcement),
                    Text(repo.openIssuesCount.toString())
                  ],
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Repository(repo: repo)
                    )
                  );
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}