import 'package:firebase_auth/firebase_auth.dart';

// need to add reload function in auth user
class AuthUser {
  final bool isEmailVerified;

  AuthUser(this.isEmailVerified);

  factory AuthUser.fromFirebase(User user) => AuthUser(
        user.emailVerified,
      );

  // adding the reload method
  Future<void> reload() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    await currentUser?.reload();
  }
}
