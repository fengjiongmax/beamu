import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:beamu/model/user_model.dart';
import 'package:beamu/model/issue_model.dart';
import 'package:beamu/model/issue_comment_model.dart';
import 'package:beamu/model/repository_model.dart';

import 'package:beamu/data/issue_data.dart';

import 'package:beamu/share/configs.dart';
import 'package:beamu/share/time_since.dart';

import 'text_edit.dart';

class Issues extends StatefulWidget{
  final RepositoryModel repo;
  final IssueModel issue;

  Issues({@required this.repo,@required this.issue}):super();

  @override
  IssuesState createState() => new IssuesState(repo: repo,issue: issue);
}

class IssuesState extends State<Issues>{
  final RepositoryModel repo;
  final IssueModel issue;
  var _comments = new List<IssueCommentModel>();
  
  bool _commentsLoading = true;

  IssuesState({@required this.repo,@required this.issue}):super();

  Widget _buildIssueComment(){
    bool _actionOpen = false;
    // if(_commentsLoading){
    //   return Center(child: Text('Fetching issue comments...'),);
    // }
    

    List<Widget> createList = new List<Widget>();
    createList.add(
      Container(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Image.network(issue.user.avatarUrl,height: 40.0,fit:BoxFit.contain),
              title: MarkdownBody(data: issue.body),
              subtitle: Text(timeSince(issue.updateAt)),
            ),
            Divider(height: 15.0)
          ],
        ),
      ),
    );
    if(_comments.isNotEmpty || _comments.length>0){
      createList.addAll(
        _comments.map((comment){
          comment.body.isEmpty?_actionOpen=!_actionOpen:_actionOpen=_actionOpen;
          return Container(
            child: Column(
              children: <Widget>[
                comment.body.isEmpty?
                ListTile(
                  title: Row(
                    children: <Widget>[
                      _actionOpen?Icon(Icons.cancel,color: Colors.red,):Icon(Icons.check_box,color: Colors.green),
                      Image.network(comment.user.avatarUrl,height: 40.0,width: 40.0,),
                      _actionOpen?Text(' Closed this issue '):Text(' Reopend this issue '),
                      Text(timeSince(comment.updatedAt),style: TextStyle(color: Colors.grey),)
                    ],
                  ),
                )
                :
                ListTile(
                  leading: Image.network(comment.user.avatarUrl,height: 40.0,width: 40.0),
                  title: MarkdownBody(data:comment.body),
                  subtitle: Text(timeSince(comment.updatedAt)),
                ),
              Divider(height: 15.0)
              ],
            ),
          );
        }).toList()
      );
      createList.add(ListTile());
    }

    return ListView(
      children: createList
    );
  }

  @override
  void initState(){
    super.initState();
    print("initiate");
    // print(_issueInputKey.);
    // getIssueComments(repo, issue.number).then((v){
    //   if(this.mounted){
    //     _comments.addAll(v);
    //     _commentsLoading=false;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    // print(_issueInputKey.currentWidget);
    return FutureBuilder(
      future: getIssueComments(repo, issue.number),
      builder: (context,snapshot){
        if(snapshot.hasData && _commentsLoading){
          _comments.addAll(snapshot.data);
          _commentsLoading = false;
        }
        return Scaffold(
            appBar: AppBar(
              title: Text(
                issue.title
              ),
            ),
            body: snapshot.hasData? _buildIssueComment():Center(child: Text('Fetching issue comments...'),),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Editor()));
              },
            ),
          );
      }
    );
  }
}