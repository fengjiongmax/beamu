import 'dart:convert';

import 'package:beamu/model/user_model.dart';
import 'package:beamu/model/repository_model.dart';

import 'package:beamu/share/requests.dart';
import 'package:beamu/share/configs.dart';

Future<UserModel> getUser(String userName) async{
  final url = config.giteaHost+'/api/v1/users/'+userName;
  final response = await httpGet(url);

  final _parsed = json.decode(response.body);
  UserModel user = UserModel.fromJson(_parsed);
  return user;
}

Future<List<UserModel>> getRepoCollaborators(RepositoryModel repo) async{
  final url = config.giteaHost+'/api/v1/repos/'+repo.owner.username+'/'+repo.name+'/collaborators';
  final response = await httpGet(url);

  final _parsed = json.decode(response.body).cast<Map<String,dynamic>>();
  List<UserModel> collaborators = _parsed.map<UserModel>((json) => UserModel.fromJson(json)).toList();
  return collaborators;
}