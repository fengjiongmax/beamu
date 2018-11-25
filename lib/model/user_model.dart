class UserModel{
  UserModel({
    this.id,
    this.username,
    this.fullName,
    this.email,
    this.avatarUrl,
    this.login
  });

  int id;
  String username;
  String fullName;
  String email;
  String avatarUrl;
  String login;

  factory UserModel.fromJson(Map<String,dynamic> json){
    return UserModel(
      id: json['id'],
      username: json['username'],
      fullName: json['fullname'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      login: json['login']
    );
  }
}