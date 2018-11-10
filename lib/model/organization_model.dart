import 'package:flutter/foundation.dart';

class OrganizationModel{
  const OrganizationModel({
    @required this.id ,
    @required this.userName,
    @required this.fullName,
    @required this.avatarUrl,
    @required this.description,
    @required this.website,
    @required this.location
  })  : assert(id != null),
        assert(userName != null),
        assert(avatarUrl != null);


  final int id;
  final String userName;
  final String fullName;
  final String avatarUrl;
  final String description;
  final String website;
  final String location;

  factory OrganizationModel.fromJson(Map<String,dynamic> json){
    return OrganizationModel(
      id: json['id'],
      userName: json['username'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
      description: json['description'],
      website: json['website'],
      location: json['location']
    );
  }
}