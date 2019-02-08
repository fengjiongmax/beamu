/*
model/repository_model.dart
*/

import 'package:beamu/model/user_model.dart';
import 'package:beamu/model/permission_model.dart';

class RepositoryModel{
  RepositoryModel({
    this.id,
    this.owner,
    this.name,
    this.fullName,
    this.description,
    this.empty,
    this.private,
    this.fork,
    this.parent,
    this.mirror,
    this.size,
    this.htmlUrl,
    this.sshUrl,
    this.cloneUrl,
    this.website,
    this.starsCount,
    this.forksCount,
    this.watchersCount,
    this.openIssuesCount,
    this.defaultBranch,
    this.archived,
    this.createdAt,
    this.updatedAt,
    this.permissions,
  });

  int id;
  UserModel owner;
  String name;
  String fullName;
  String description;
  bool empty;
  bool private;
  bool fork;
  RepositoryModel parent;
  bool mirror;
  int size;
  String htmlUrl;
  String sshUrl;
  String cloneUrl;
  String website;
  int starsCount;
  int forksCount;
  int watchersCount;
  int openIssuesCount;
  String defaultBranch;
  bool archived;
  DateTime createdAt;
  DateTime updatedAt;
  PermissionModel permissions;

  factory RepositoryModel.fromJson(Map<String,dynamic> json){
    return RepositoryModel(
      id: json['id'],
      owner: UserModel.fromJson(json['owner']),
      name: json['name'],
      fullName: json['full_name'],
      description: json['description'],
      private: json['private'],
      fork: json['fork'],
      empty: json['empty'],
      parent: json['parent']==null?null:RepositoryModel.fromJson(json['parent']),
      mirror: json['mirror'],
      size: json['size'],
      htmlUrl: json['html_url'],
      sshUrl: json['ssh_url'],
      cloneUrl: json['clone_url'],
      website: json['website'],
      starsCount: json['stars_count'],
      forksCount: json['forks_count'],
      watchersCount: json['watchers_count'],
      openIssuesCount: json['open_issues_count'],
      defaultBranch: json['default_branch'],
      archived: json['archived'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      permissions: PermissionModel.fromJson(json['permissions']),
    );
  }
}