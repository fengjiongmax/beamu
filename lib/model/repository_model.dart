import 'package:flutter/foundation.dart';

import 'user_model.dart';
import 'permission_model.dart';

class RepositoryModel{
  const RepositoryModel({
    @required this.id,
    @required this.owner,
    @required this.name,
    @required this.fullName,
    @required this.description,
    @required this.private,
    @required this.fork,
    @required this.parent,
    @required this.empty,
    @required this.mirror,
    @required this.size,
    @required this.htmlUrl,
    @required this.sshUrl,
    @required this.cloneUrl,
    @required this.website,
    @required this.startsCount,
    @required this.forksCount,
    @required this.openIssuesCount,
    @required this.defaultBranch,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.permissions,
  });

  final int id;
  final UserModel owner;
  final String name;
  final String fullName;
  final String description;
  final bool private;
  final bool fork;
  final RepositoryModel parent;
  final bool empty;
  final bool mirror;
  final int size;
  final String htmlUrl;
  final String sshUrl;
  final String cloneUrl;
  final String website;
  final int startsCount;
  final int forksCount;
  final int openIssuesCount;
  final String defaultBranch;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PermissionModel permissions;

  factory RepositoryModel.fromJson(Map<String,dynamic> json){
    return RepositoryModel(
      id: json['id'],
      owner: UserModel.fromJson(json['owner']),
      name: json['name'],
      fullName: json['full_name'],
      description: json['description'],
      private: json['private'],
      fork: json['fork'],
      parent: json['parent']==null?null:RepositoryModel.fromJson(json['parent']),
      empty: json['empty'],
      mirror: json['mirror'],
      size: json['size'],
      htmlUrl: json['html_url'],
      sshUrl: json['ssh_url'],
      cloneUrl: json['clone_url'],
      website: json['website'],
      startsCount: json['starts_count'],
      forksCount: json['forks_count'],
      openIssuesCount: json['open_issues_count'],
      defaultBranch: json['default_branch'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      permissions: PermissionModel.fromJson(json['permissions']),
    );
  }
}