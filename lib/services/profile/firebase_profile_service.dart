import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkus/services/profile/profile_cloud.dart';
import 'package:linkus/services/profile/profile_constants.dart';
import 'package:linkus/services/profile/profile_exceptions.dart';
import 'package:linkus/services/profile/profile_service.dart';

class FirebaseProfileService implements ProfileService {
  final profiles = FirebaseFirestore.instance.collection("Users");

  @override
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
  }) async {
    try {
      if (profilePic != null) {
        await profiles.doc(email).update({profilePicCloud: profilePic});
      }
      await profiles.doc(email).update({
        nameCloud: name,
        teleHandleCloud: teleHandle,
        yearCloud: year,
        degreeCloud: degree,
        hobby1Cloud: hobby1,
        hobby2Cloud: hobby2,
        hobby3Cloud: hobby3
      });
    } catch (e) {
      throw CouldNotUpdateProfileException();
    }
  }

  @override
  Stream<ProfileCloud> fetchProfile({required String email}) {
    return profiles.doc(email).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return ProfileCloud.fromSnapshot(snapshot);
      } else {
        throw Exception('Profile not found');
      }
    });
  }

  @override
  Future<ProfileCloud> createNewProfile({required String email}) async {
    final DocumentReference<Map<String, dynamic>> document =
        profiles.doc(email);

    await document.set({
      profilePicCloud: '',
      nameCloud: '',
      teleHandleCloud: '',
      yearCloud: '',
      degreeCloud: '',
      hobby1Cloud: '',
      hobby2Cloud: '',
      hobby3Cloud: ''
    });
    final fetchedProfile = await document.get();
    return ProfileCloud(
        email: fetchedProfile.id,
        profilePic: '',
        name: '',
        teleHandle: '',
        year: '',
        degree: '',
        hobby1: '',
        hobby2: '',
        hobby3: '');
  }

  @override
  Future<bool> profileExists({required String email}) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await profiles.doc(email).get();
    if (snapshot.exists) {
      return true;
    }
    return false;
  }
}
