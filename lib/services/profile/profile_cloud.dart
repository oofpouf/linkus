import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:linkus/services/profile/profile_constants.dart';

@immutable
class ProfileCloud {
  final String email;
  final String profilePic;
  final String name;
  final String teleHandle;
  final String year;
  final String degree;
  final String hobby1;
  final String hobby2;
  final String hobby3;

  const ProfileCloud(
      {required this.email,
      required this.profilePic,
      required this.name,
      required this.teleHandle,
      required this.year,
      required this.degree,
      required this.hobby1,
      required this.hobby2,
      required this.hobby3});

  factory ProfileCloud.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return ProfileCloud(
      email: snapshot.id,
      profilePic: data?[profilePicCloud] ?? '',
      name: data?[nameCloud] ?? '',
      teleHandle: data?[teleHandleCloud] ?? '',
      year: data?[yearCloud] ?? '',
      degree: data?[degreeCloud] ?? '',
      hobby1: data?[hobby1Cloud] ?? '',
      hobby2: data?[hobby2Cloud] ?? '',
      hobby3: data?[hobby3Cloud] ?? '',
    );
  }

  bool hasEmptyFields() {
    return name.isEmpty ||
        teleHandle.isEmpty ||
        year.isEmpty ||
        degree.isEmpty ||
        hobby1.isEmpty ||
        hobby2.isEmpty ||
        hobby3.isEmpty;
  }

  List<Map<String, dynamic>> toListMap() {
    return [
      {
        profilePicCloud: profilePic,
        nameCloud: name,
        teleHandleCloud: teleHandle,
        yearCloud: year,
        degreeCloud: degree,
        hobby1Cloud: hobby1,
        hobby2Cloud: hobby2,
        hobby3Cloud: hobby3,
      }
    ];
  }
}
