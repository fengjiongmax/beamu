/*
model/user_model.dart
*/

import 'dart:convert';

class UserModel{
  UserModel({
    this.id,
    this.username,
    this.fullName,
    this.email,
    this.avatarUrl,
    this.login
  });

  int id;
  String username;
  String fullName;
  String email;
  String avatarUrl;
  String login;

  factory UserModel.fromJson(Map<String,dynamic> json){
    return UserModel(
      id: json['id'],
      username: json['username'],
      fullName: json['full_name'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      login: json['login']
    );
  }

  Map<String,dynamic> toJson() =>{
    'id':id,
    'username':username,
    'full_name':fullName,
    'email':email,
    'avatar_url':avatarUrl,
    'login':login
  };

  String toJsonString(){
    return json.encode(this.toJson());
  }

}