/*
model/tracked_time_model.dart
*/

import 'dart:convert';

class TrackTimeModel{
  TrackTimeModel({
    this.created,
    this.id,
    this.issueId,
    this.time,
    this.userId
  });

  DateTime created;
  int id;
  int issueId;
  int time;//time in seconds
  int userId;

  factory TrackTimeModel.fromJson(Map<String,dynamic> json){
    return TrackTimeModel(
      created: json['created']==null?null:DateTime.parse(json['created']),
      id: json['id'],
      issueId: json['issue_id'],
      time: json['time'],
      userId: json['user_id']
    );
  }
}

class AddTimeOption{
  AddTimeOption({
    this.time
  });

  int time;

  Map<String,dynamic> toJson()=>{
    'time':time == null?null:time
  };

  String toJsonString(){
    return json.encode(this.toJson());
  }
}