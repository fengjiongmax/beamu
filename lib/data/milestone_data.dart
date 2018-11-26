import 'dart:convert';

import 'package:beamu/model/milestone_model.dart';
import 'package:beamu/model/repository_model.dart';

import 'package:beamu/share/requests.dart';
import 'package:beamu/share/configs.dart';

Future<List<MilestoneModel>> getRepoMilestones(RepositoryModel repo) async{
  final url = config.giteaHost + '/api/v1/repos/'+repo.owner.username+'/'+repo.name+'/milestones';

  final response = await httpGet(url);
  final _parsed = json.decode(response.body).cast<Map<String,dynamic>>();

  List<MilestoneModel> milestones = _parsed.map<MilestoneModel>((json) => MilestoneModel.fromJson(json)).toList();
  return milestones;
}