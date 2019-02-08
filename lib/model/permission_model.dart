/*
model/permission_model.dart
*/

class PermissionModel{
  PermissionModel({
    this.admin,
    this.push,
    this.pull
  });
  
  bool admin;
  bool push;
  bool pull;

  factory PermissionModel.fromJson(Map<String,dynamic> json){
    return PermissionModel(
      admin: json['admin'],
      pull: json['pull'],
      push: json['push']
    );
  }
}