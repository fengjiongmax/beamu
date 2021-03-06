/*
share/requests.dart
*/

import 'dart:core';
import 'package:http/http.dart';

import 'package:beamu/share/configs.dart';

Map<String,String> _defaultHeader = {
  'content-type':'application/json',
  'Authorization':'token '+config.userToken
};

Future<Response> httpGet(String url,[Map<String,String> header]) async{
  Client client = Client();
  return await client.get(Uri.encodeFull(url),headers: header==null?_defaultHeader:header);
}

Future<Response> httpPost(String url,dynamic body,[Map<String,String> header]) async{
  Client client = Client();
  return await client.post(Uri.encodeFull(url), 
                          body: body,
                          headers:header == null?_defaultHeader:header
                          );
}

Future<Response> httpPatch(String url,dynamic body,[Map<String,String> header]) async{
  Client client = Client();
  return await client.patch(Uri.encodeFull(url),
                            body: body,
                            headers: header==null? _defaultHeader:header
                            );
}

Future<Response> httpPut(String url,dynamic body,[Map<String,String> header]) async{
  Client client = Client();
  return await client.put(Uri.encodeFull(url),
                            body: body,
                            headers: header==null? _defaultHeader:header
                            );
}

Future<Response> httpDelete(String url,[Map<String,String> header]) async{
  Client client = Client();
  return await client.delete(Uri.encodeFull(url),
                            headers: header==null? _defaultHeader:header
                            );
}
