import 'package:flutter/material.dart';

import 'package:beamu/components/labels_display.dart';
import 'package:beamu/components/select_label.dart';
import 'package:beamu/components/select_milestone.dart';

import 'package:beamu/model/issue_model.dart';
import 'package:beamu/model/label_model.dart';
import 'package:beamu/model/milestone_model.dart';
import 'package:beamu/model/user_model.dart';

class IssueCreator extends StatefulWidget{
  final List<LabelModel> repoLabels;
  final List<MilestoneModel> repoMilestones;
  final List<UserModel> repoParticipants;

  IssueCreator({this.repoLabels,this.repoMilestones,this.repoParticipants,Key key})
              :super(key:key);

  @override
  _IssueCreatorState createState() => _IssueCreatorState();
}

class _IssueCreatorState extends State<IssueCreator>{
  TextEditingController _titleEditController;
  TextEditingController _bodyEditController;

  List<LabelModel> _selectedLabel;
  MilestoneModel _milestone;
  List<UserModel> _assignees;

  @override
  void initState(){
    _titleEditController = new TextEditingController();
    _bodyEditController = new TextEditingController();
    _selectedLabel = new List<LabelModel>();
    _assignees = new List<UserModel>();
    super.initState();
  }

  @override
  void dispose(){
    _titleEditController.dispose();
    _bodyEditController.dispose();
    super.dispose();
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
                  controller: _titleEditController,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Title'
                  ),
                ),
              ),
              SizedBox(height: 10,),
              
              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: TextField(
                  controller: _bodyEditController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Body',
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
                Text('No label')
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
                Text('No Milestone')
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
                trailing: IconButton(icon: Icon(Icons.settings),onPressed: (){},),
              ),
              _assignees == null || _assignees.length ==0?
                Text('No Assignees')
                :ListView(
                  children: _assignees.map((a){
                    return Card(
                      child: ListTile(
                        leading: Image.network(a.avatarUrl),
                        title: Text(a.username),
                      ),
                    );
                  }).toList(),
                ),
              
              ListTile(
                title: RaisedButton(
                  child: Text('Create'),
                  onPressed: (){
                    
                  },
                ),
              )
              
            ],
          ),
        ),     
      )
    );
  }
}

