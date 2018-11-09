import 'package:flutter/foundation.dart';

class UserModel{
  const UserModel({
    @required this.id,
    @required this.username,
    @required this.fullName,
    @required this.email,
    @required this.avatarUrl
  })  : assert(id != null),
        assert(username != null),
        assert(email != null);
  final int id;
  final String username;
  final String fullName;
  final String email;
  final String avatarUrl;

  factory UserModel.fromJson(Map<String,dynamic> json){
    return UserModel(
      id: json['id'],
      username: json['username'],
      fullName: json['fullname'],
      email: json['email'],
      avatarUrl: json['avatarUrl']
    );
  }
}