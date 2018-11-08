import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

import 'package:beamu/share/config_keys.dart';
import 'config_keys.dart';

enum LOGIN_STAT{ failed,success,invalid_host,timeout}

_getConfig() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var isLogin = prefs.getBool(DONE_LOGIN);
  return isLogin;
}

Future<LOGIN_STAT> loginAction(String username,String password,String gogsHost) async{
  while(gogsHost.substring(gogsHost.length-1,gogsHost.length) == '/'){
    gogsHost = gogsHost.substring(0,gogsHost.length-1);//remove the last '/'
  }
  var retVal = LOGIN_STAT.failed;
  Client client = Client();
  var loginUrl = gogsHost+"/api/v1/users/"+username+"/tokens";
  var loginCredential = username+":"+password;
  Map<String,String> header = new Map<String,String>();
  const base64 = Base64Codec();
  var authentication = base64.encode(utf8.encode(loginCredential));
  header['Authorization'] = "Basic "+ authentication;

  doLogin() async{
    var rtVal = LOGIN_STAT.failed;
    final response = await client.get(loginUrl,headers: header).timeout(Duration(seconds: 30),onTimeout: (){
      rtVal = LOGIN_STAT.timeout;
    });
    if(rtVal != LOGIN_STAT.timeout){
      switch(response.statusCode){
        case 200:
          rtVal = LOGIN_STAT.success;
          break;
        case 401:
          rtVal = LOGIN_STAT.failed;
          break;
        default : // this includes 404
          rtVal = LOGIN_STAT.invalid_host;
          break;
      }
    }
    return rtVal;
  }
  
  await doLogin().then((value) async{
    if(value == LOGIN_STAT.success){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(DONE_LOGIN, true);
      await prefs.setString(GOGS_HOST, gogsHost);
      // TODO: save username and password via secure_storage ,or get access token and save .
    }
  });
  return retVal;
}

Future<bool> loginCHK() async{
  var retVal = false;
  await _getConfig().then((onValue){
    print(onValue);
    retVal=onValue;
  });
  return retVal;
}


