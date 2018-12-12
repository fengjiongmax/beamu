import 'dart:convert';

import 'package:beamu/model/user_model.dart';
import 'package:beamu/model/repository_model.dart';
import 'package:beamu/model/organization_model.dart';

import 'package:beamu/share/requests.dart';
import 'package:beamu/share/configs.dart';

Future<UserModel> getUser(String userName) async{
  final url = config.giteaHost+'/api/v1/users/'+userName;
  final response = await httpGet(url);

  final _parsed = json.decode(response.body);
  UserModel user = UserModel.fromJson(_parsed);
  return user;
}

Future<List<UserModel>> getRepoCollaborators(String ownerName,String repoName) async{
  final url = config.giteaHost+'/api/v1/repos/'+ownerName+'/'+repoName+'/collaborators';
  final response = await httpGet(url);

  final _parsed = json.decode(response.body).cast<Map<String,dynamic>>();
  List<UserModel> collaborators = _parsed.map<UserModel>((json) => UserModel.fromJson(json)).toList();
  return collaborators;
}

Future<List<UserModel>> getOrgMembers(String orgName) async{
  final url = config.giteaHost +'/api/v1/orgs/'+orgName+'/members';
  final response = await httpGet(url);

  final _parsed = json.decode(response.body).cast<Map<String,dynamic>>();
  List<UserModel> members = _parsed.map<UserModel>((json)=>UserModel.fromJson(json));

  return members;
}

