import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:linkus/enums/map_list_contains.dart';
import 'package:linkus/services/profile/profile_cloud.dart';
import 'package:linkus/services/profile/profile_constants.dart';
import 'package:linkus/services/profile/profile_exceptions.dart';
import 'package:linkus/services/profile/profile_service.dart';

void main() {
  group('FirebaseProfileStorage', () {
    final mockProfileService = MockProfileService();
    const Map<String, dynamic> newProfile = {
      profilePicCloud: '',
      nameCloud: '',
      teleHandleCloud: '',
      yearCloud: '',
      degreeCloud: '',
      hobby1Cloud: '',
      hobby2Cloud: '',
      hobby3Cloud: ''
    };
    const Map<String, dynamic> testProfile = {
      profilePicCloud: 'profile_pic_url',
      nameCloud: 'John Doe',
      teleHandleCloud: 'johndoe',
      yearCloud: '2022',
      degreeCloud: 'Computer Science',
      hobby1Cloud: 'Hobby 1',
      hobby2Cloud: 'Hobby 2',
      hobby3Cloud: 'Hobby 3',
    };

    test('createProfile should create profile', () async {
      await mockProfileService.createNewProfile(email: 'test@example.com');
      final List<Map<String, dynamic>> actualNewProfile =
          await mockProfileService
              .fetchProfile(email: 'test@example.com')
              .first
              .then((profileCloud) => profileCloud.toListMap());
      expect(actualNewProfile, const MapListContains(newProfile));
    });

    test('updateProfile should update profile', () async {
      await mockProfileService.updateProfile(
        email: 'test@example.com',
        profilePic: 'profile_pic_url',
        name: 'John Doe',
        teleHandle: 'johndoe',
        year: '2022',
        degree: 'Computer Science',
        hobby1: 'Hobby 1',
        hobby2: 'Hobby 2',
        hobby3: 'Hobby 3',
      );
      final List<Map<String, dynamic>> actualNewProfile =
          await mockProfileService
              .fetchProfile(email: 'test@example.com')
              .first
              .then((profileCloud) => profileCloud.toListMap());
      expect(actualNewProfile, const MapListContains(testProfile));
    });

    // ColoudNotUpdateProfile exception should be thrown if id cannot be found
    test('CouldNotUpdateProfileException thrown if wrong email', () async {
      final badEmail = mockProfileService.updateProfile(
        email: 'wrong@example.com',
        profilePic: 'pfp_url',
        name: 'John Smith',
        teleHandle: 'johnsmith',
        year: '2023',
        degree: 'Computer Engineering',
        hobby1: 'Hobby 4',
        hobby2: 'Hobby 5',
        hobby3: 'Hobby 6',
      );
      expect(badEmail,
          throwsA(const TypeMatcher<CouldNotUpdateProfileException>()));
    });

    test('fetchProfile should fetch profile', () async {
      final List<Map<String, dynamic>> actualNewProfile =
          await mockProfileService
              .fetchProfile(email: 'test@example.com')
              .first
              .then((profileCloud) => profileCloud.toListMap());
      expect(actualNewProfile, const MapListContains(testProfile));
    });

    test('profileExists should check if profile exists', () async {
      bool realProfile =
          await mockProfileService.profileExists(email: 'test@example.com');
      bool fakeProfile =
          await mockProfileService.profileExists(email: 'wrong@example.com');

      expect(realProfile, true);
      expect(fakeProfile, false);
    });
  });
}

class MockProfileService implements ProfileService {
  final fakeProfiles = FakeFirebaseFirestore().collection('Users');
  bool shouldThrowException = false;

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
        await fakeProfiles.doc(email).update({profilePicCloud: profilePic});
      }
      await fakeProfiles.doc(email).update({
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
    return fakeProfiles.doc(email).snapshots().map((snapshot) {
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
        fakeProfiles.doc(email);

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
        await fakeProfiles.doc(email).get();
    if (snapshot.exists) {
      return true;
    }
    return false;
  }
}
