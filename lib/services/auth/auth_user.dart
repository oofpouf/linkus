import 'package:firebase_auth/firebase_auth.dart';

// need to add reload function in auth user
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;

  const AuthUser({
    required this.isEmailVerified,
    required this.email,
    required this.id,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
      email: user.email!, isEmailVerified: user.emailVerified, id: user.uid);

  // adding the reload method
  Future<void> reload() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    await currentUser?.reload();
  }
}
