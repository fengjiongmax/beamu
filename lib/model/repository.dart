import 'package:flutter/foundation.dart';

import 'user.dart';
import 'permission.dart';

class Repository{
  const Repository({
    @required this.id,
    @required this.owner,
    @required this.fullName,
    @required this.private,
    @required this.fork,
    @required this.htmlUrl,
    @required this.cloneUrl,
    @required this.sshUrl,
    @required this.permissions
  })  : assert(id != null),
        assert(owner != null),
        assert(fullName != null),
        assert(private != null),
        assert(fork != null),
        assert(htmlUrl != null),
        assert(cloneUrl != null),
        assert(sshUrl != null),
        assert(permissions != null);

  final int id;
  final User owner;
  final String fullName;
  final bool private;
  final bool fork;
  final String htmlUrl;
  final String cloneUrl;
  final String sshUrl;
  final Permission permissions;
}