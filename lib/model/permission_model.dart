import 'package:flutter/foundation.dart';

class PermissionModel{
  const PermissionModel({
    @required this.admin,
    @required this.push,
    @required this.pull
  })  : assert(admin != null),
        assert(push != null),
        assert(pull != null);
  final bool admin;
  final bool push;
  final bool pull;

  factory PermissionModel.fromJson(Map<String,dynamic> json){
    return PermissionModel(
      admin: json['admin'],
      pull: json['pull'],
      push: json['push']
    );
  }
}