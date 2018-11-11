import 'package:flutter/material.dart';

import 'package:beamu/data/issue_data.dart';

import 'package:beamu/model/repository_model.dart';
import 'package:beamu/model/issue_model.dart';

import 'package:beamu/share/time_since.dart';
import 'issue.dart';


class Repository extends StatefulWidget{
  final RepositoryModel repo;

  Repository({@required this.repo}):super();

  @override
  State<StatefulWidget> createState() => new RepositoryState(repo: repo);

}

class RepositoryState extends State<Repository>{
  final RepositoryModel repo;
  List<IssueModel> _issues;

  var _issueLoading = true;

  RepositoryState({@required this.repo}):super();

  Widget _buildIssueList(){
    if(_issueLoading){
      return Center(child: Text('Fetching data..'));
    }
    if(_issues.isEmpty || _issues.length==0){
      return Center(child: Text('Issue not found'));
    }
    return ListView(
        children: _issues.map((issue){
          String updateSince = 'Updated '+timeSince(issue.updateAt);
          return Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Text('#'+issue.number.toString()),
                  title: Text(
                    issue.title,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    ),
                  subtitle: Text(updateSince),
                  trailing: Column(
                    children: <Widget>[
                      Icon(Icons.chat),
                      Text(issue.comments.toString())
                    ],
                  ),
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context)=>Issues(repo: repo,issue: issue)
                      )
                    );
                  },
                ),
                Divider(height: 15.0)
              ],
            ),
          );
        }).toList()
      );
  }

  @override
  void initState(){
    super.initState();
    getRepoIssues(repo.owner.username, repo.name).then((v){
      if(this.mounted){
        setState(() {
                _issues=v;
                _issueLoading=false;
              });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(repo.owner.username+"/"+repo.name),
      ),
      body: _buildIssueList(),
    );
  }
}