import 'package:beamu/model/repository_model.dart';

import 'package:beamu/share/configs.dart';
import 'package:beamu/share/requests.dart';

Future<String> getREADME(RepositoryModel repo) async{
  final url = config.gogsHost+"/api/v1/repos/"
                            +repo.owner.username+"/"
                            +repo.name+"/raw/master/README.md";
  final response = await httpGet(url);

  if(response.statusCode != 200){
    return null;
  }
  return response.body;
}