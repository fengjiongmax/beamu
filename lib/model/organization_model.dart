/*
model/organization_model.dart
*/

class OrganizationModel{
  OrganizationModel({
    this.id ,
    this.userName,
    this.fullName,
    this.avatarUrl,
    this.description,
    this.website,
    this.location
  });

  int id;
  String userName;
  String fullName;
  String avatarUrl;
  String description;
  String website;
  String location;

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