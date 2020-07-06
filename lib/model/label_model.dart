/*
model/label_model.dart
*/

//import 'package:flutter/foundation.dart';

class LabelModel {
  LabelModel({this.id, this.name, this.color, this.url});

  int id;
  String name;
  String color;
  String url;

  factory LabelModel.fromJson(Map<String, dynamic> json) {
    return LabelModel(
        id: json['id'],
        name: json['name'],
        color: json['color'],
        url: json['url']);
  }
}
