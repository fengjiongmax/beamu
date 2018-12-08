import 'package:flutter/material.dart';

import 'package:beamu/model/milestone_model.dart';

class MilestoneSelector extends StatelessWidget{
  final List<MilestoneModel> repoMilestones;
  final MilestoneModel selectedMilestone;
  final ValueChanged<MilestoneModel> onSelected;

  MilestoneSelector({this.repoMilestones,this.selectedMilestone,this.onSelected,Key key})
    :super(key:key);

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text('Select Milestone'),
      content: ListView(
        children: repoMilestones==null?<Widget>[]:repoMilestones.map((m){
          return Card(
            child: ListTile(
              title: Text(m.title),
              onTap: (){
                onSelected(m);
              },
            ),
          );
        }).toList(),
      ),
      actions: <Widget>[
        MaterialButton(
          child: Text('Clear'),
          onPressed: (){
            onSelected(null);
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