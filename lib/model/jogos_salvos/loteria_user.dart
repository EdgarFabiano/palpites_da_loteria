import 'package:firebase_auth/firebase_auth.dart';

class LoteriaUser {
  LoteriaUser({this.email, this.displayName});

  LoteriaUser.fromJson(Map<String, Object?> json)
      : this(
          email: json['email']! as String,
          displayName: json['displayName']! as String,
        );

  LoteriaUser.fromFirebaseUser(User user)
      : this(
          email: user.email,
          displayName: user.displayName,
        );

  final String? email;
  final String? displayName;

  Map<String, Object?> toJson() {
    return {
      'email': email,
      'displayName': displayName,
    };
  }
}
