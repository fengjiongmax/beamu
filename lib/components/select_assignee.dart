import 'package:flutter/material.dart';

import 'package:beamu/model/user_model.dart';

class AssigneeSelector extends StatefulWidget{
  final List<UserModel> assigneeCandidate;
  final List<UserModel> assignees;

  AssigneeSelector({this.assigneeCandidate,this.assignees,Key key})
          :assert(assignees != null), super(key:key);

  @override
  _AssigneesSelectorState createState() => _AssigneesSelectorState();
}

class _AssigneesSelectorState extends State<AssigneeSelector>{
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Assignee'),
      content: ListView(
        children: widget.assigneeCandidate == null? <Widget>[]:widget.assigneeCandidate.map((c){
          return Card(
            child: Container(
              child: ListTile(
                leading: CircleAvatar(
                  child: Image.network(c.avatarUrl),
                ),
                title: Text(c.username),
                trailing: widget.assignees.contains(c)?Icon(Icons.check):null,
                onTap: (){
                  if(widget.assignees.contains(c)){
                    widget.assignees.remove(c);
                  }
                  else{
                    widget.assignees.add(c);
                  }
                  setState(() { });
                },
              ),
            ),
          );
        }).toList(),
      ),
      actions: <Widget>[
        MaterialButton(
          child: Text('Clear'),
          onPressed: (){
            widget.assignees.clear();
            Navigator.pop(context);
          },
        ),
        MaterialButton(
          child: Text('Close'),
          onPressed: (){
            Navigator.pop(context);
          },
        )
      ],
    );
  }

}

