import 'dart:convert';

import 'package:beamu/share/requests.dart';
import 'package:beamu/share/configs.dart';
import 'package:beamu/model/issue_model.dart';

Future<List<IssueModel>> getIssues(String userName,String repoName) async{
  var _url = config.gogsHost+'/api/v1/repos/'+userName+'/'+repoName+'/issues';

  var _response = await httpGet(_url);
  if(_response.statusCode == 404) return new List<IssueModel>();
  var _parsed = json.decode(_response.body).cast<Map<String,dynamic>>();

  List<IssueModel> issues = _parsed.map<IssueModel>((json) => IssueModel.fromJson(json)).toList();
  return issues;
}