import 'dart:convert';

import 'package:beamu/share/requests.dart';
import 'package:beamu/share/configs.dart';

import 'package:beamu/model/repository_model.dart';
import 'package:beamu/model/issue_model.dart';
import 'package:beamu/model/issue_comment_model.dart';

Future<List<IssueModel>> getRepoIssues(RepositoryModel repo,{bool closed = false}) async{
  var _url = config.gogsHost+'/api/v1/repos/'+repo.owner.username+'/'+repo.name+'/issues'+(closed?'?state=closed':'');

  var _response = await httpGet(_url);
  if(_response.statusCode == 404) return new List<IssueModel>();
  var _parsed = json.decode(_response.body).cast<Map<String,dynamic>>();

  List<IssueModel> issues = _parsed.map<IssueModel>((json) => IssueModel.fromJson(json)).toList();
  return issues;
}

Future<List<IssueCommentModel>> getIssueComments(RepositoryModel repo,int number) async{
  var _url = config.gogsHost +'/api/v1/repos/'+repo.owner.username+'/'+repo.name+'/issues/'+number.toString()+'/comments';

  var _response = await httpGet(_url);
  if(_response.statusCode == 404) return new List<IssueCommentModel>();
  var _parsed = json.decode(_response.body).cast<Map<String,dynamic>>();

  List<IssueCommentModel> comments = _parsed.map<IssueCommentModel>((json) => IssueCommentModel.fromJson(json)).toList();
  return comments;
}