/*
data/issue_data.dart
*/

import 'dart:convert';
import 'dart:core';

import 'package:beamu/share/requests.dart';
import 'package:beamu/share/configs.dart';

import 'package:beamu/model/issue_model.dart';
import 'package:beamu/model/issue_comment_model.dart';

Future<List<IssueModel>> getRepoIssues(String ownerName, String repoName,
    {bool closed = false}) async {
  var _url = config.giteaHost +
      '/api/v1/repos/' +
      ownerName +
      '/' +
      repoName +
      '/issues' +
      (closed ? '?state=closed' : '');

  var _response = await httpGet(_url);
  if (_response.statusCode == 404) return new List<IssueModel>();
  var _parsed = json.decode(_response.body).cast<Map<String, dynamic>>();

  List<IssueModel> issues =
      _parsed.map<IssueModel>((json) => IssueModel.fromJson(json)).toList();
  return issues;
}

Future<List<IssueCommentModel>> getIssueComments(
    String ownerName, String repoName, int number) async {
  var _url = config.giteaHost +
      '/api/v1/repos/' +
      ownerName +
      '/' +
      repoName +
      '/issues/' +
      number.toString() +
      '/comments';

  var _response = await httpGet(_url);
  if (_response.statusCode == 404) return new List<IssueCommentModel>();
  var _parsed = json.decode(_response.body).cast<Map<String, dynamic>>();

  List<IssueCommentModel> comments = _parsed
      .map<IssueCommentModel>((json) => IssueCommentModel.fromJson(json))
      .toList();
  return comments;
}

Future<IssueModel> updateIssue(
    String ownerName, String repoName, IssueModel issue) async {
  var _url = config.giteaHost +
      '/api/v1/repos/' +
      ownerName +
      '/' +
      repoName +
      '/issues/' +
      issue.number.toString();
  var _response =
      await httpPatch(_url, SubmitIssueModel.fromIssue(issue).toJsonString());

  final _parsed = json.decode(_response.body);
  IssueModel returnIssue = IssueModel.fromJson(_parsed);
  return returnIssue;
}

Future<IssueModel> createIssue(
    String ownerName, String repoName, SubmitIssueModel toCreateIssue) async {
  var _url = config.giteaHost +
      '/api/v1/repos/' +
      ownerName +
      '/' +
      repoName +
      '/issues';
  var _response = await httpPost(_url, toCreateIssue.toJsonString());

  final _parsed = json.decode(_response.body);
  IssueModel returnIssue = IssueModel.fromJson(_parsed);
  return returnIssue;
}
