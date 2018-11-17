import 'dart:convert';

import 'package:beamu/model/organization_model.dart';

import 'package:beamu/share/requests.dart';
import 'package:beamu/share/configs.dart';


Future<List<OrganizationModel>> getSelfOrganizations() async{
  final url = config.gogsHost+'/api/v1/user/orgs';

  final response = await httpGet(url);
  final _parsed = json.decode(response.body).cast<Map<String,dynamic>>();

  List<OrganizationModel> orgs = _parsed.map<OrganizationModel>((json)=> OrganizationModel.fromJson(json)).toList();
  return orgs;
}

Future<List<OrganizationModel>> getUserOrganizations(String userName) async{
  final url = config.gogsHost+'/api/v1/users/'+userName+'/orgs';

  final response = await httpGet(url);
  final _parsed = json.decode(response.body).cast<Map<String,dynamic>>();

  List<OrganizationModel> orgs = _parsed.map<OrganizationModel>((json)=> OrganizationModel.fromJson(json)).toList();
  return orgs;
}