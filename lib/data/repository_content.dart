/*
data/repository_content.dart
*/

//import 'package:beamu/model/repository_model.dart';

import 'package:beamu/share/configs.dart';
import 'package:beamu/share/requests.dart';

Future<String> getREADME(
    String ownerName, String repoName, String branchName) async {
  final url = config.giteaHost +
      "/api/v1/repos/" +
      ownerName +
      "/" +
      repoName +
      "/raw/" +
      branchName +
      "/README.md";
  final response = await httpGet(url);

  if (response.statusCode != 200) {
    return null;
  }
  return response.body;
}
