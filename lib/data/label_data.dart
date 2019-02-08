/*
data/label_data.dart
*/

import 'dart:convert';

import 'package:beamu/model/label_model.dart';
import 'package:beamu/model/repository_model.dart';

import 'package:beamu/share/configs.dart';
import 'package:beamu/share/requests.dart';

Future<List<LabelModel>> getRepoLabels(String ownerName,String repoName) async{
  final url = config.giteaHost+'/api/v1/repos/'+ownerName+'/'+repoName+'/labels';
  final response = await httpGet(url);

  final _parsed = json.decode(response.body).cast<Map<String,dynamic>>();
  List<LabelModel> labels = _parsed.map<LabelModel>((json) => LabelModel.fromJson(json)).toList();
  return labels;
}

Future<List<LabelModel>> createIssueLabels(String ownerName,String repoName,int issueIndex,List<int> labelIndices) async{
  final url = config.giteaHost+'/api/v1/repos/'+ownerName+'/'+repoName+'/issues/'+issueIndex.toString()+'/labels';

  final Map<String,List<int>> body = {"labels":labelIndices};

  final response = await httpPost(url,json.encode(body));

  final _parsed = json.decode(response.body).cast<Map<String,dynamic>>();

  List<LabelModel> labels = _parsed.map<LabelModel>((json)=> LabelModel.fromJson(json)).toList();

  return labels;
}

Future<List<LabelModel>> updateIssueLabels(String ownerName,String repoName,int issueIndex,List<int> labelIndices) async{
  final url = config.giteaHost+'/api/v1/repos/'+ownerName+'/'+repoName+'/issues/'+issueIndex.toString()+'/labels';

  final Map<String,List<int>> body = {"labels":labelIndices};

  final response = await httpPut(url,json.encode(body));

  final _parsed = json.decode(response.body).cast<Map<String,dynamic>>();

  List<LabelModel> labels = _parsed.map<LabelModel>((json)=> LabelModel.fromJson(json)).toList();

  return labels;
}

Future<bool> removeIssueLabels(String ownerName,String repoName,int issueIndex) async{
  final url = config.giteaHost+'/api/v1/repos/'+ownerName+'/'+repoName+'/issues/'+issueIndex.toString()+'/labels';

  final response = await httpDelete(url);

  return response.statusCode == 204;

}

