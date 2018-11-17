import 'package:flutter/foundation.dart';

class MilestoneModel{
  const MilestoneModel({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.state,
    @required this.openIssues,
    @required this.closedIssues,
    @required this.closedAt,
    @required this.dueOn
  });

  final int id;
  final String title;
  final String description;
  final String state;
  final int openIssues;
  final int closedIssues;
  final DateTime closedAt;
  final DateTime dueOn;

  factory MilestoneModel.fromJson(Map<String,dynamic> json){
    return MilestoneModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      state: json['state'],
      openIssues: json['open_issues'],
      closedIssues: json['closed_issues'],
      closedAt: json['closed_at'] == null? null : DateTime.parse(json['closed_at']),
      dueOn: json['due_on'] == null? null : DateTime.parse(json['due_on'])
    );
  }
}