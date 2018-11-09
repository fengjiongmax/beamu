import 'dart:convert';

import 'package:beamu/model/repository_model.dart';
import 'package:beamu/share/requests.dart';
import 'package:beamu/share/configs.dart';

Future<List<RepositoryModel>> getSelfRepositories() async{
  final url = config.gogsHost+'/api/v1/user/repos';
  final response = await httpGet(url);

  final _parsed = json.decode(response.body).cast<Map<String,dynamic>>();
  List<RepositoryModel> repos = _parsed.map<RepositoryModel>((json) => RepositoryModel.fromJson(json)).toList();
  return repos;
}