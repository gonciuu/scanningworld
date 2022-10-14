import 'package:scanning_world/data/remote/models/auth/session.dart';
import 'package:scanning_world/data/remote/models/user/user.dart';

class AuthResult {
  final Session session;
  final User user;

  AuthResult({
    required this.session,
    required this.user,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) => AuthResult(
        session: Session.fromJson(json["tokens"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "tokens": session.toJson(),
        "user": user.toJson(),
      };
}
