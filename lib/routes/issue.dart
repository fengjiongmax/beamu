import 'package:flutter/material.dart';

import 'package:beamu/model/user_model.dart';
import 'package:beamu/model/issue_model.dart';
import 'package:beamu/model/issue_comment_model.dart';
import 'package:beamu/model/repository_model.dart';

import 'package:beamu/data/issue_data.dart';

import 'package:beamu/components/markdown_render.dart';

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
    // print(issue.labels);

    List<Widget> createList = new List<Widget>();
    createList.add(
      Card(
        child: Column(
          children: <Widget>[
            Container(
              child: ListTile(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                leading: Image.network(issue.user.avatarUrl,height: 40.0,fit:BoxFit.contain),
                title:  Text(issue.user.username+","+timeSince(issue.createAt)),
              ),
              decoration: new BoxDecoration(
                color: Color.fromARGB(255, 239, 240, 241)
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: MarkdownRender(
                data: issue.body
              ),
            ),
            issue.labels != null && issue.labels.isNotEmpty?
            Container(
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
            )
            :SizedBox(height: 0),
          ],
        ),
      )
    );
    if(_comments.isNotEmpty || _comments.length>0){
      createList.addAll(
        _comments.map((comment){
          comment.body.isEmpty?_actionOpen=!_actionOpen:_actionOpen=_actionOpen;
          return comment.body.isNotEmpty?
          Card(
            child:  Column(
              children: <Widget>[
                Container(
                  child: ListTile(
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    leading: Image.network(issue.user.avatarUrl,height: 40.0,fit:BoxFit.contain),
                    title: Text(comment.user.username+","+timeSince(comment.createdAt)),
                  ),
                  decoration: new BoxDecoration(
                    color: Color.fromARGB(255, 239, 240, 241)
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: MarkdownRender(data: comment.body),
                )
              ],
            )
          )
          :
          Row(
            children: <Widget>[
              SizedBox(width: 12.0),
              _actionOpen?Icon(Icons.cancel,color: Colors.red,):Icon(Icons.check_box,color: Colors.green),
              SizedBox(width: 12.0),
              Image.network(comment.user.avatarUrl,height: 20.0,fit:BoxFit.contain),
              SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    (_actionOpen?'Closed by ':' Reopend by ')+comment.user.username+","+timeSince(comment.createdAt),
                    softWrap: true,
                  ),
                ],
              )
            ]
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
    getIssueComments(repo, issue.number).then((v){
      if(_commentsLoading && this.mounted){
         setState(() {
          _comments.addAll(v);
          _commentsLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(_issueInputKey.currentWidget);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            issue.title
          ),
        ),
        body: _commentsLoading? Center(child: Text('Fetching issue comments...'),):_buildIssueComment(),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: (){
        //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Editor()));
        //   },
        // ),
      );
  }
}