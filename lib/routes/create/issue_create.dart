import 'package:flutter/material.dart';

import 'package:beamu/components/labels_display.dart';
import 'package:beamu/components/select_label.dart';
import 'package:beamu/components/select_milestone.dart';
import 'package:beamu/components/select_assignee.dart';
import 'package:beamu/components/center_text.dart';

import 'package:beamu/model/repository_model.dart';
import 'package:beamu/model/issue_model.dart';
import 'package:beamu/model/label_model.dart';
import 'package:beamu/model/milestone_model.dart';
import 'package:beamu/model/user_model.dart';

import 'package:beamu/data/issue_data.dart';

class IssueCreator extends StatefulWidget{
  final RepositoryModel repo;
  final List<LabelModel> repoLabels;
  final List<IssueModel> repoIssues;//depends not available in api yet.
  final List<MilestoneModel> repoMilestones;
  final List<UserModel> assigneeCandidate;

  IssueCreator({this.repo,this.repoLabels,this.repoIssues,this.repoMilestones,this.assigneeCandidate,Key key})
              :super(key:key);

  @override
  _IssueCreatorState createState() => _IssueCreatorState();
}

class _IssueCreatorState extends State<IssueCreator>{
  TextEditingController _titleEditController;
  TextEditingController _bodyEditController;
  FocusNode _titleFocusNode;
  FocusNode _bodyFocusNode;

  List<LabelModel> _selectedLabel;
  MilestoneModel _milestone;
  List<UserModel> _assignees;

  bool _isBodyEmpty = false;
  bool _isTitleEmpty = false;
  bool _createPressed = false;

  @override
  void initState(){
    _titleEditController = new TextEditingController();
    _bodyEditController = new TextEditingController();
    _titleFocusNode = new FocusNode();
    _bodyFocusNode = new FocusNode();
    _selectedLabel = new List<LabelModel>();
    _assignees = new List<UserModel>();
    super.initState();
  }

  @override
  void dispose(){
    _titleEditController.dispose();
    _bodyEditController.dispose();
    _titleFocusNode.dispose();
    _bodyFocusNode.dispose();
    super.dispose();
  }

  void _onCreatePress() {
    if(_titleEditController.text.isEmpty){
      setState(() {
        _isTitleEmpty=true;
      });
      return;
    }
    else{
      setState(() {
        _isTitleEmpty=false;
      });
    }
    if(_bodyEditController.text.isEmpty){
      setState(() {
        _isBodyEmpty=true;
      });
      return;
    }
    else{
      setState(() {
        _isBodyEmpty=false;
      });
    }

    if(!_createPressed){
      _createPressed= true;
      SubmitIssueModel _toCreate = new SubmitIssueModel(
        title: _titleEditController.text,
        body: _bodyEditController.text,
        assignees: _assignees,
        labels: _selectedLabel,
        milestone: _milestone,
        closed:false,
      );

      createIssue(widget.repo, _toCreate).then((v){
        widget.repoIssues.add(v);
        Navigator.of(context).pop();
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Issue'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: TextField(
                  focusNode: _titleFocusNode,
                  controller: _titleEditController,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Title',
                    errorText: _isTitleEmpty?'Title should not be empty':null
                  ),
                ),
              ),
              SizedBox(height: 10,),
              
              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: TextField(
                  focusNode: _bodyFocusNode,
                  controller: _bodyEditController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Body',
                    errorText: _isBodyEmpty?'Body should not be empty':null
                  ),
                ),
              ),
              SizedBox(height: 10,),

              ListTile(
                leading: Text('Labels'),
                title: Divider(color: Colors.grey,),
                trailing: IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (context)=>new LabelSelector(
                          repoLabels: widget.repoLabels,
                          selectedLabels: _selectedLabel,
                        )
                    ).then((v){
                        _selectedLabel.sort((a,b){return a.id>b.id?1:0;});//sort by the order as shown in the labels list
                        setState(() { });
                      }
                    );
                  },
                ),
              ),
              _selectedLabel==null || _selectedLabel.length == 0?
                CenterText(centerText:'No label')
                :Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    children: _selectedLabel.map((l){
                      return LabelCard(label: l,);
                    }).toList(),
                  ),
                ),

              ListTile(
                leading: Text('Milestones'),
                title: Divider(color: Colors.grey,),
                trailing: IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (context) => new MilestoneSelector(
                        repoMilestones: widget.repoMilestones,
                        selectedMilestone: _milestone,
                        onSelected: (m){
                          setState(() {
                            _milestone=m;
                          });
                          Navigator.pop(context);
                        },
                      )
                    );
                  },
                ),
              ),
              _milestone == null?
                CenterText(centerText:'No milestone')
                :Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Card(
                    child: ListTile(
                      title: Text(_milestone.title),
                    ),
                  ),
                ),

              ListTile(
                leading: Text('Asignees'),
                title: Divider(color: Colors.grey,),
                trailing: IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (context) => new AssigneeSelector(
                        assigneeCandidate: widget.assigneeCandidate,
                        assignees: _assignees,
                      )
                    ).then((v){
                      _assignees.sort((a,b){return a.id>b.id? 1:0;});
                      setState(() { });
                    });
                  },
                ),
              ),
              _assignees == null || _assignees.length ==0?
                CenterText(centerText:'No Assignees')
                :Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    children: _assignees.map((a){
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Image.network(a.avatarUrl),
                          ),
                          title: Text(a.username),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              
              ListTile(
                title: RaisedButton(
                  child: Text('Create'),
                  onPressed:_onCreatePress,
                ),
              )
            ],
          ),
        ),     
      )
    );
  }
}

