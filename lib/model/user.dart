import 'package:flutter/foundation.dart';

class User{
  const User({
    @required this.id,
    @required this.username,
    @required this.fullName,
    @required this.email,
    @required this.avatarUrl
  })  : assert(id != null),
        assert(username != null),
        assert(fullName != null),
        assert(email != null),
        assert(avatarUrl != null);
  final int id;
  final String username;
  final String fullName;
  final String email;
  final String avatarUrl;
}