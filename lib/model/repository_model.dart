import 'package:beamu/model/user_model.dart';
import 'package:beamu/model/permission_model.dart';

class RepositoryModel{
  RepositoryModel({
    this.id,
    this.owner,
    this.name,
    this.fullName,
    this.description,
    this.private,
    this.fork,
    this.parent,
    this.empty,
    this.mirror,
    this.size,
    this.htmlUrl,
    this.sshUrl,
    this.cloneUrl,
    this.website,
    this.startsCount,
    this.forksCount,
    this.openIssuesCount,
    this.defaultBranch,
    this.createdAt,
    this.updatedAt,
    this.permissions,
  });

  int id;
  UserModel owner;
  String name;
  String fullName;
  String description;
  bool private;
  bool fork;
  RepositoryModel parent;
  bool empty;
  bool mirror;
  int size;
  String htmlUrl;
  String sshUrl;
  String cloneUrl;
  String website;
  int startsCount;
  int forksCount;
  int openIssuesCount;
  String defaultBranch;
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