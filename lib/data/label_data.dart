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