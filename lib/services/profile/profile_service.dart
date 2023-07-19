import 'package:linkus/services/profile/profile_cloud.dart';

abstract class ProfileService {
  Future<void> updateProfile({
    required String email,
    String? profilePic,
    required String name,
    required String teleHandle,
    required String year,
    required String degree,
    required String hobby1,
    required String hobby2,
    required String hobby3,
  });
  Stream<ProfileCloud> fetchProfile({required String email});
  Future<ProfileCloud> createNewProfile({required String email});
  Future<bool> profileExists({required String email});
}
