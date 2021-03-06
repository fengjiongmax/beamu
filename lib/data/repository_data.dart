/*
data/repository_data.dart
*/

import 'dart:convert';

import 'package:beamu/model/repository_model.dart';

import 'package:beamu/share/requests.dart';
import 'package:beamu/share/configs.dart';

Future<List<RepositoryModel>> getSelfRepositories() async{
  final url = config.giteaHost+'/api/v1/user/repos';
  final response = await httpGet(url);

  final _parsed = json.decode(response.body).cast<Map<String,dynamic>>();
  List<RepositoryModel> repos = _parsed.map<RepositoryModel>((json) => RepositoryModel.fromJson(json)).toList();
  return repos;
}

Future<List<RepositoryModel>> getRepositories(String userName) async{
  final url = config.giteaHost+'/api/v1/users/'+userName+'/repos';
  final response = await httpGet(url);

  final _parsed = json.decode(response.body).cast<Map<String,dynamic>>();
  List<RepositoryModel> repos = _parsed.map<RepositoryModel>((json) => RepositoryModel.fromJson(json)).toList();
  return repos;
}

Future<String> getDefaultREADME(String ownerName,String repoName,String branchName) async{
  final url = config.giteaHost+"/api/v1/repos/"
                            +ownerName+"/"
                            +repoName+"/raw/"
                            +branchName+"/README.md";
  final response = await httpGet(url);

  return response.statusCode == 200? response.body : null;
}

Future<RepositoryModel> getRepoInfo(String ownerName,String repoName) async{
  final url = config.giteaHost+'/api/v1/repos/'
                              +ownerName+'/'
                              +repoName;
  final response = await httpGet(url);
  final _parsed = json.decode(response.body);
  RepositoryModel _returnRepo = RepositoryModel.fromJson(_parsed);
  return _returnRepo;
}