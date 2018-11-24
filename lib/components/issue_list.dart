import 'package:flutter/material.dart';

import 'package:beamu/routes/issue.dart';

import 'package:beamu/model/repository_model.dart';
import 'package:beamu/model/issue_model.dart';

import 'package:beamu/components/loading.dart';
import 'package:beamu/components/center_text.dart';

class IssueList extends StatelessWidget{
  final RepositoryModel repo;
  final List<IssueModel> issues;

  const IssueList({this.repo,this.issues,Key key}):super(key:key);

  @override
  Widget build(BuildContext context) {

  if(issues==null){
    return LoadingContent();
  }
    
  if(issues ==null || issues.isEmpty || issues.length==0){
    return CenterText(centerText: 'Issue not found',);
  }
  return ListView(
      children: issues.map((issue){
        // String updateSince = timeSince(issue.updateAt);
        return Card(
          child: Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(16, 0, 14, 0),
                  title: Text(
                    issue.title,
                    softWrap: true,
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
}