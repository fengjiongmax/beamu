import 'package:flutter/foundation.dart';

class Permission{
  const Permission({
    @required this.admin,
    @required this.push,
    @required this.pull
  })  : assert(admin != null),
        assert(push != null),
        assert(pull != null);
  final bool admin;
  final bool push;
  final bool pull;
}