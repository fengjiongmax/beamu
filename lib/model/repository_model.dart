import 'package:flutter/foundation.dart';

import 'user_model.dart';
import 'permission_model.dart';

class RepositoryModel{
  const RepositoryModel({
    @required this.id,
    @required this.owner,
    @required this.fullName,
    @required this.private,
    @required this.fork,
    @required this.htmlUrl,
    @required this.cloneUrl,
    @required this.sshUrl,
    @required this.permissions
  })  : assert(id != null),
        assert(owner != null),
        assert(private != null),
        assert(fork != null),
        assert(permissions != null);

  final int id;
  final UserModel owner;
  final String fullName;
  final bool private;
  final bool fork;
  final String htmlUrl;
  final String cloneUrl;
  final String sshUrl;
  final PermissionModel permissions;

  factory RepositoryModel.fromJson(Map<String,dynamic> json){
    return RepositoryModel(
      id: json['id'],
      owner: UserModel.fromJson(json['owner']),
      fullName: json['fullName'],
      private: json['private'],
      fork: json['fork'],
      htmlUrl: json['htmlUrl'],
      cloneUrl: json['cloneUrl'],
      sshUrl: json['sshUrl'],
      permissions: PermissionModel.fromJson(json['permissions'])
    );
  }
}