import 'package:flutter/foundation.dart';

class TokenModel{
  const TokenModel({
    @required this.name,
    @required this.sha1
  })  : assert(name != null),
        assert(sha1 != null);
  final String name;
  final String sha1;

  factory TokenModel.fromJson(Map<String,dynamic> json){
    return TokenModel(
      name: json['name'] as String,
      sha1: json['sha1'] as String
    );
  }

  Map<String,dynamic> toJson()=>{
    'name':name,
    'sha1':sha1
  };
}