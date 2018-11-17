library secure_config;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const DONE_LOGIN = 'Done_Login';
const GOGS_HOST = 'GOGS_Host';
const USERNAME = 'UserName';
const PASSWORD = 'Password';
const TOKEN = 'Token';
const AVATAR = 'Avatar';

const APP_NAME='BEAMU';

final SecureConfigReader config = new SecureConfigReader();

class SecureConfigReader{
  String userToken;
  String userName;
  String gogsHost;
  String avatar;

  final FlutterSecureStorage config = new FlutterSecureStorage();

  Future<String> readValue(String key) async{
    String value = await config.read(key: key);
    return value;
  }

  saveValue(String key,String value) async{
    await config.write(key: key,value: value);
  }

  deleteKey(String key) async{
    await config.delete(key: key);
  }

  setToken(String token) async {
    await saveValue(TOKEN, token);
    await setLocalToken();
  }

  clearAll() async{
    await config.deleteAll();
  }
  
  Future<bool> setLocalToken() async{
    var result = false;
    var _config = await config.readAll();
    if(_config[GOGS_HOST] != null && _config[GOGS_HOST].length>0
      && _config[USERNAME] != null && _config[USERNAME].length>0
      && _config[TOKEN] != null && _config[TOKEN].length>0
       )
      {
        gogsHost = _config[GOGS_HOST];
        userName = _config[USERNAME];
        userToken = _config[TOKEN];
        // avatar = _config[AVATAR];
        result = true;
      }

    return result;
  }
}


