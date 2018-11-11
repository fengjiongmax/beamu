import 'package:flutter/material.dart';

import 'package:beamu/model/repository_model.dart';
import 'package:beamu/share/time_since.dart';

import 'package:beamu/routes/repository.dart';

Widget buildReposList(BuildContext context,List<RepositoryModel> reposList,[String username]){
    if(reposList.isEmpty || reposList.length == 0){
      return Center(
        child: Text('0 repository.'),
      );
    }

    if(username.isNotEmpty){
      reposList = reposList.where((w){return w.owner.username == username;}).toList();
    }

    return ListView(
      children: reposList.map((repo){
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