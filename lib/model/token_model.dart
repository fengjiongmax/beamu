class TokenModel{
  TokenModel({
    this.name,
    this.sha1
  });
  String name;
  String sha1;

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