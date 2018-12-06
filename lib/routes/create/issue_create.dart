import 'package:flutter/material.dart';

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
  _IssueCreatorState createState() => _IssueCreatorState(repoLabels: repoLabels,
                                                        repoMilestones: repoMilestones,
                                                        repoParticipants: repoParticipants);
}

class _IssueCreatorState extends State<IssueCreator>{
  final List<LabelModel> repoLabels;
  final List<MilestoneModel> repoMilestones;
  final List<UserModel> repoParticipants;

  _IssueCreatorState({this.repoLabels,this.repoMilestones,this.repoParticipants})
                    :super();

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

  void _displayLables() {
    showDialog(
      context: context,
      builder: (context)=>AlertDialog(
        title: Text('Select labels'),
        content: ListView(
          children: repoLabels ==null?<Widget>[]: repoLabels.map((l){
            Color colorPicker = new Color(int.parse('0xFF'+l.color));
            var y = 0.2126*colorPicker.red + 0.7152*colorPicker.green + 0.0722*colorPicker.blue;
            return Card(
              child: Container(
                color: colorPicker,
                child: ListTile(
                  title: Text(
                    l.name,
                    style: TextStyle(
                      color:y<128? Colors.white : Colors.black,
                    ),
                  ),
                  trailing: _selectedLabel != null && _selectedLabel.contains(l)? Icon(Icons.check):null,
                  onTap: (){
                    //TODO: show checkbox icon when label is selected
                    _selectedLabel.add(l);
                  },
                ),
              ),
            );
          }).toList(),
        ),
        actions: <Widget>[
          MaterialButton(
            child: Text('Cancel'),
            onPressed: (){
              Navigator.pop(context);
              setState(() { });
            },
          )
        ],
      )
    );
  }

  void _displayMilestones(){

  }

  void _displayCollaborators(){

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
                  onPressed: ()=> _displayLables(),
                ),
              ),
              _selectedLabel==null || _selectedLabel.length == 0?
                Text('no label')
                :ListView(
                  //TODO: this will cause problem when _selectedLabel is not null and length>0
                  children: _selectedLabel.map((l){
                    Color colorPicker = new Color(int.parse('0xFF'+l.color));
                    var y = 0.2126*colorPicker.red + 0.7152*colorPicker.green + 0.0722*colorPicker.blue;
                    return Card(
                      color: colorPicker,
                      child: ListTile(
                        title: Text(
                          l.name,
                          style: TextStyle(
                            color: y<128?Colors.white:Colors.black
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

              ListTile(
                leading: Text('Milestones'),
                title: Divider(color: Colors.grey,),
                trailing: IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: (){

                  },
                ),
              ),
              _milestone == null?
                Text('No Milestone')
                :Card(
                  child: Text(
                    _milestone.title
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

