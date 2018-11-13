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
          String updateSince = timeSince(issue.updateAt);
          return Card(
            child: Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(16, 0, 14, 0),
                    // dense: true,
                    // leading: Text('#'+issue.number.toString()),
                    title: Text(
                      issue.title,
                      softWrap: true,
                      // overflow: TextOverflow.ellipsis,
                      // maxLines: 1,
                      ),
                    subtitle: Text("#"+issue.number.toString()+" by "+issue.user.username),
                    trailing: Container(
                      width: 40,
                      height: 10,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.chat),
                          Text(issue.comments.toString())    
                        ],
                      ),
                    ),
                    // Column(
                    //   children: <Widget>[
                    //     Icon(Icons.chat),
                    //     Text(issue.comments.toString())
                    //   ],
                    // ),
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context)=>Issues(repo: repo,issue: issue)
                        )
                      );
                    },
                  ),
                  issue.labels != null?Container(
                    height: 35.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:  issue.labels.map((label){
                        Color colorPicker = new Color(int.parse('0xFF'+label.color));
                        var y = 0.2126*colorPicker.red + 0.7152*colorPicker.green + 0.0722*colorPicker.blue;
                        return Container(
                          height: 12.0,
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color:colorPicker
                          ),
                          child: Text(
                            label.name,
                            style: TextStyle(
                              color:y<128? Colors.white : Colors.black,
                            ),
                          ),
                        );
                      }).toList()
                    ),
                  ):null,
                ],
              ),
            )
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