/*
model/issue_comment_model.dart
*/

import 'user_model.dart';

class IssueCommentModel{
  IssueCommentModel({
    this.id,
    this.htmlUrl,
    this.pullRequestUrl,
    this.issueUrl,
    this.user,
    this.body,
    this.createdAt,
    this.updatedAt
  });

  int id;
  String htmlUrl;
  String pullRequestUrl;
  String issueUrl;
  UserModel user;
  String body;
  DateTime createdAt;
  DateTime updatedAt;

  factory IssueCommentModel.fromJson(Map<String,dynamic> json){
    return IssueCommentModel(
      id: json['id'],
      htmlUrl: json['html_url'],
      pullRequestUrl: json['pull_request_url'],
      issueUrl: json['issue_url'],
      user: UserModel.fromJson(json['user']),
      body: json['body'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at'])
    );
  }
}