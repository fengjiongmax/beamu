import 'dart:convert';

import 'package:beamu/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

import 'package:beamu/data/user_data.dart';
import 'package:beamu/model/token_model.dart';
import 'package:beamu/share/configs.dart';
import 'package:beamu/share/requests.dart';

enum LOGIN_STAT{ failed,success,invalid_host,timeout}

Future<LOGIN_STAT> loginAction(String username,String password,String giteaHost) async{
  while(giteaHost.substring(giteaHost.length-1,giteaHost.length) == '/'){
    giteaHost = giteaHost.substring(0,giteaHost.length-1);//remove the last '/'
  }
  var retVal = LOGIN_STAT.failed;
  var loginUrl = giteaHost+"/api/v1/users/"+username+"/tokens";
  var loginCredential = username+":"+password;
  Map<String,String> header = new Map<String,String>();
  const base64 = Base64Codec();
  var authentication = base64.encode(utf8.encode(loginCredential));
  header['Authorization'] = "Basic "+ authentication;

  doLogin() async{
    Response rtVal ;
    final response = await httpGet(loginUrl,header).timeout(Duration(seconds: 30),onTimeout: (){
      return null;
    });
    rtVal = response;
    return rtVal;
  }

  createToken() async{
    header['content-type'] = "application/json";
    String postBody = '{"name":"'+APP_NAME+'"}';
    Response rtVal;
    final response = await httpPost(loginUrl,postBody,header).timeout(Duration(seconds: 30),onTimeout: (){
      return null;
    });
    rtVal = response;
    return rtVal;
  }
  
  await doLogin().then((value) async{
    if(value != null){
     if(value.statusCode==200){
          retVal = LOGIN_STAT.success;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool(DONE_LOGIN, true);
          await config.saveValue(GITEA_HOST, giteaHost);
          await config.saveValue(USERNAME, username);
          await config.saveValue(PASSWORD, password);

          //parse response
          var parsed = json.decode(value.body).cast<Map<String,dynamic>>();
          List<TokenModel> tokens = parsed.map<TokenModel>((json)=> TokenModel.fromJson(json)).toList();

          TokenModel token ;
          if(tokens.length>0){
            token = tokens.firstWhere((w){
              return w.name==APP_NAME;
            });
          }
          
          if(token == null){//not found,create one
            var response = await createToken();
            token = TokenModel.fromJson(json.decode(response.body));
          }
          await config.setToken(token.sha1);
      }else if(value.statusCode==401){
            retVal = LOGIN_STAT.failed;
      }else{// this includes 404
            retVal = LOGIN_STAT.invalid_host;
      }
    }else{
      retVal = LOGIN_STAT.timeout;
    }
  });
  return retVal;
}

Future<UserModel> getUserInfo() async{
  var user = await getUser(config.userName);
  return user;
}

Future<bool> loginCHK() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(DONE_LOGIN) && await config.setLoginToken(); // find token locally
}

Future<bool> logout() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  return await config.clearAll();
}

