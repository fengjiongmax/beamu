import 'package:flutter/foundation.dart';

import 'user_model.dart';
import 'label_model.dart';
import 'milestone_model.dart';
//import 'pull_request_model.dart';

class IssueModel{
  const IssueModel({
    @required this.id,
    @required this.url,
    @required this.number,
    @required this.user,
    @required this.title,
    @required this.body,
    @required this.labels,
    @required this.milestone,
    @required this.assignee,
    @required this.assignees,
    @required this.state,
    @required this.comments,
    @required this.createAt,
    @required this.updateAt
    //@required this.PullRequest
  });

  final int id;
  final String url;
  final int number;
  final UserModel user;
  final String title;
  final String body;
  final List<LabelModel> labels;
  final MilestoneModel milestone;
  final UserModel assignee;
  final List<UserModel> assignees;
  final String state;
  final int comments;
  final DateTime createAt;
  final DateTime updateAt;

  //pull requests are not inplemented in gogs api v1 yet
  //final PullRequesModel pullRequest;

  factory IssueModel.fromJson(Map<String,dynamic> json){
    List<LabelModel> labels;
    if(json['labels'] != null){
      labels = new List<LabelModel>();
      for(final item in json['labels']){
        labels.add(LabelModel.fromJson(item));
      }
    }

    List<UserModel> assignees;
    if(json['assignees'] != null){
      assignees = new List<UserModel>();
      for(final item in json['assignees']){
        assignees.add(UserModel.fromJson(item));
      }
    }

    return IssueModel(
      id: json['id'],
      url: json['url'],
      number: json['number'],
      user: UserModel.fromJson(json['user']),
      title: json['title'],
      body: json['body'],
      labels: labels,
      milestone: json['milestone']==null?null:MilestoneModel.fromJson(json['milestone']),
      assignee: json['assignee']==null? null:UserModel.fromJson(json['assignee']),
      assignees: assignees,
      state: json['state'],
      comments: json['comments'],
      createAt: DateTime.parse(json['created_at']),
      updateAt: DateTime.parse(json['updated_at']),
      //pullRequest: PullRequest.fromJson(json['pull_request'])
    );
  }
}