import 'dart:async';

import 'package:beamu/components/drawer.dart';
import 'package:flutter/material.dart';

import 'package:beamu/routes/text_edit.dart';

import 'package:beamu/model/issue_model.dart';
import 'package:beamu/model/issue_comment_model.dart';
import 'package:beamu/model/repository_model.dart';

import 'package:beamu/data/issue_data.dart';

import 'package:beamu/components/markdown_render.dart';
import 'package:beamu/components/loading.dart';

import 'package:beamu/share/time_since.dart';
import 'package:beamu/share/configs.dart';

class Issues extends StatefulWidget{
  final RepositoryModel repo;
  final IssueModel issue;

  Issues({@required this.repo,@required this.issue,Key key}):super(key:key);

  @override
  IssuesState createState() => new IssuesState(repo: repo,issue: issue);
}

//TODO:use tabview to render issue:issue/comments,labels,milestone,assignees,participants
class IssuesState extends State<Issues>{
  final RepositoryModel repo;
  final IssueModel issue;

  IssueModel _renderIssue;
  TextEditingController _titleEditController;
  FocusNode _focusNode = new FocusNode();
  var _comments = new List<IssueCommentModel>();
  bool _commentsLoading = true;
  bool _issueUpdated = false;
  bool _editTitle = false;

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
                trailing: issue.user.username==config.userName?
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>Editor(url: config.giteaHost+'/api/v1/repos/'+repo.owner.username+'/'+repo.name+'/issues/'+issue.number.toString()
                                                                    ,method:FINISH_METHOD.PATCH
                                                                    ,issue: issue
                                                                    ,body: BODY.ISSUE,))
                      );
                    },
                  )
                  : 
                  null,
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

    if(_commentsLoading){
      createList.add(LoadingContent());
    } else if(_comments.isNotEmpty || _comments.length>0){
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
                    // trailing: comment.user.username==config.userName?
                    //   IconButton(
                    //     icon: Icon(Icons.edit),
                    //     onPressed: (){
                    //       Navigator.of(context).push(
                    //         MaterialPageRoute(builder: (context)=>Editor(url: config.giteaHost+'/api/v1/repos/'
                    //                                                                          +repo.owner.username+'/issues/comments/'
                    //                                                                          +comment.id.toString()
                    //                                                     ,method:FINISH_METHOD.PATCH
                    //                                                     ,body: BODY.COMMENT
                    //                                                     ,comment: comment,))
                    //       );
                    //     },
                    //   )
                    //   : 
                    //   null,
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
    _issueUpdated=false;
    _renderIssue = issue;
    if(_commentsLoading && this.mounted){
      getIssueComments(repo, _renderIssue.number).then((v){
          setState(() {
          _comments.addAll(v);
          _commentsLoading = false;
        });
      });
    }
    _titleEditController = new TextEditingController(text: issue.title);
    super.initState();
  }

  Future<bool> _onWillPop(){
    if(_focusNode.hasFocus){
      if(_titleEditController.text == issue.title){
        _focusNode.unfocus();
      } else {
        showDialog(
          context: context,
          builder: (context)=> AlertDialog(
            title: Text('Save changes?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: ()=>_saveTitle()
              ),
              FlatButton(
                child: Text('No'),
                onPressed: (){
                  _focusNode.unfocus();
                },
              )
            ],
          )
        );
      }
      setState(() {
        _editTitle=false;
      });
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void dispose(){
    _focusNode.dispose();
    super.dispose();
  }

  PreferredSizeWidget _editIssueTitle(){
    return AppBar(
      automaticallyImplyLeading: false,
      title: TextField(
        controller: _titleEditController,
        focusNode: _focusNode,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.save),
          onPressed: () =>_saveTitle()
        )
      ],
    );
  } 

  Future<void> _saveTitle() async{
    _focusNode.unfocus();
    issue.title = _titleEditController.text;
    var updated = await updateIssue(repo, issue);
    if(updated != null){
      setState(() {
        // issue.title = _titleEditController.text;
        issue.comments+=1;
        _renderIssue=updated;
        _issueUpdated = true;
      });
    }
    setState(() {
      _editTitle=false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // print(_issueInputKey.currentWidget);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: BeamuDrawer(),
        appBar: _editTitle?_editIssueTitle(): AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: Text(
            //TODO: display title with multiple line
            _renderIssue.title
          ),
          actions: repo.owner.username == config.userName && _renderIssue.user.username == config.userName ?
            <Widget>[            
              PopupMenuButton(
                onSelected: (PopChoice v){
                  switch(v.title){
                    case 'Edit Title':
                      setState(() {
                        _editTitle=true;
                        FocusScope.of(context).requestFocus(_focusNode);
                      });
                      break;
                  }
                },
                itemBuilder: (BuildContext context){
                  return popChoices.map((choice){
                    return PopupMenuItem<PopChoice>(
                      value: choice,
                      child: Row(
                        children: <Widget>[
                          Icon(choice.icon),
                          SizedBox(width: 5,),
                          Text(choice.title)
                        ],
                      ),
                    );
                  }).toList();
                },
              )
            ]
            :null,
        ),
        body: _buildIssueComment(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_comment),
          onPressed: () async{
            await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (context)=> Editor(url: config.giteaHost+'/api/v1/repos/'
                                                                +repo.owner.username+'/'
                                                                +repo.name+'/issues/'
                                                                +_renderIssue.number.toString()+'/comments'
                                            ,body: BODY.COMMENT
                                            ,method: FINISH_METHOD.POST,))
            );
            var _retList = await getIssueComments(repo, _renderIssue.number);
            if(this.mounted){
              setState(() {
                _comments.clear();
                _comments.addAll(_retList);
              });
            }
          },
        ),
      ),
    );
  }
}


class PopChoice{
  const PopChoice({this.title,this.icon});

  final String title;
  final IconData icon;
}

const List<PopChoice> popChoices = const <PopChoice>[
  const PopChoice(title: 'Edit Title',icon: Icons.border_color)
];