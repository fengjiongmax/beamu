import 'package:flutter/foundation.dart';

import 'user_model.dart';

class IssueCommentModel{
  const IssueCommentModel({
    @required this.id,
    @required this.htmlUrl,
    @required this.user,
    @required this.body,
    @required this.createdAt,
    @required this.updatedAt
  });

  final int id;
  final String htmlUrl;
  final UserModel user;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory IssueCommentModel.fromJson(Map<String,dynamic> json){
    return IssueCommentModel(
      id: json['id'],
      htmlUrl: json['html_url'],
      user: UserModel.fromJson(json['user']),
      body: json['body'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at'])
    );
  }
}