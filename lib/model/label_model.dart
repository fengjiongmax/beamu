import 'package:flutter/foundation.dart';

class LabelModel{
  const LabelModel({
    @required this.id,
    @required this.name,
    @required this.color,
    @required this.url
  });

  final int id;
  final String name;
  final String color;
  final String url;

  factory LabelModel.fromJson(Map<String,dynamic> json){
    return LabelModel(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      url: json['url']
    );
  }
}