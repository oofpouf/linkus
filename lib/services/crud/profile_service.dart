import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

import 'crud_exceptions.dart';

class ProfileService {
  Database? _db;

  List<DatabaseProfile> _profiles = [];

  static final ProfileService _shared = ProfileService._sharedInstance();
  ProfileService._sharedInstance();
  factory ProfileService() => _shared;

  final _profilesStreamController =
      StreamController<List<DatabaseProfile>>.broadcast();
  Stream<List<DatabaseProfile>> get allProfiles =>
      _profilesStreamController.stream;
  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cacheProfiles() async {
    final allProfiles = await getAllProfiles();
    _profiles = allProfiles.toList();
    _profilesStreamController.add(_profiles);
  }

  Future<DatabaseProfile> updateProfile({
    required DatabaseProfile profile,
    required File profilePic,
    required String name,
    required String teleHandle,
    required int year,
    required String degree,
    required String course1,
    required String course2,
    required String course3,
    required String hobby1,
    required String hobby2,
    required String hobby3,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // make sure profile exists
    await getProfile(id: profile.id);

    // update DB
    final updatesCount = await db.update(profileTable, {
      profilePicColumn: profilePic,
      nameColumn: name,
      teleHandleColumn: teleHandle,
      yearColumn: year,
      degreeColumn: degree,
      course1Column: course1,
      course2Column: course2,
      course3Column: course3,
      hobby1Column: hobby1,
      hobby2Column: hobby2,
      hobby3Column: hobby3,
      isSyncedColumn: 0,
    });

    if (updatesCount == 0) {
      throw CouldNotUpdateProfile();
    } else {
      final updatedProfile = await getProfile(id: profile.id);
      _profiles.removeWhere((profile) => profile.id == updatedProfile.id);
      _profiles.add(updatedProfile);
      _profilesStreamController.add(_profiles);
      return updatedProfile;
    }
  }

  Future<Iterable<DatabaseProfile>> getAllProfiles() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final profiles = await db.query(
      profileTable,
    );

    return profiles.map((profileRow) => DatabaseProfile.fromRow(profileRow));
  }

  Future<DatabaseProfile> getProfile({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final profiles = await db.query(
      profileTable,
      limit: 1,
      where: "id = ?",
      whereArgs: [id],
    );

    if (profiles.isEmpty) {
      throw CouldNotFindProfile();
    } else {
      final profile = DatabaseProfile.fromRow(profiles.first);
      _profiles.removeWhere((profile) => profile.id == id);
      _profiles.add(profile);
      _profilesStreamController.add(_profiles);
      return profile;
    }
  }

  Future<int> deleteAllProfiles() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(profileTable);
    _profiles = [];
    _profilesStreamController.add(_profiles);
    return numberOfDeletions;
  }

  Future<void> deleteProfile({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      profileTable,
      where: "id = ?",
      whereArgs: [id],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteProfile();
    } else {
      _profiles.removeWhere((profile) => profile.id == id);
      _profilesStreamController.add(_profiles);
    }
  }

  Future<DatabaseProfile> createProfile({required DatabaseUser owner}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // make sure owner exists in the database with the correct id
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }

    const profilePic = null;
    const name = "";
    const teleHandle = "";
    const year = 0;
    const degree = "";
    const course1 = "";
    const course2 = "";
    const course3 = "";
    const hobby1 = "";
    const hobby2 = "";
    const hobby3 = "";

    // create the profile page
    final profileId = await db.insert(profileTable, {
      userIdColumn: owner.id,
      profilePicColumn: profilePic,
      nameColumn: name,
      teleHandleColumn: teleHandle,
      yearColumn: year,
      degreeColumn: degree,
      course1Column: course1,
      course2Column: course2,
      course3Column: course3,
      hobby1Column: hobby1,
      hobby2Column: hobby2,
      hobby3Column: hobby3,
      isSyncedColumn: 1
    });

    final profile = DatabaseProfile(
      id: profileId,
      userId: owner.id,
      profilePic: profilePic,
      name: name,
      teleHandle: teleHandle,
      year: year,
      degree: degree,
      course1: course1,
      course2: course2,
      course3: course3,
      hobby1: hobby1,
      hobby2: hobby2,
      hobby3: hobby3,
      isSynced: true,
    );

    _profiles.add(profile);
    _profilesStreamController.add(_profiles);

    return profile;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );

    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }

    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });

    return DatabaseUser(
      id: userId,
      email: email,
    );
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      // empty
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      //create the user table
      await db.execute(createUserTable);

      //create the profile table
      await db.execute(createProfileTable);
      await _cacheProfiles();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => "Person, ID = $id, email = $email";

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseProfile {
  final int id;
  final int userId;
  final File profilePic;
  final String name;
  final String teleHandle;
  final int year;
  final String degree;
  final String course1;
  final String course2;
  final String course3;
  final String hobby1;
  final String hobby2;
  final String hobby3;
  final bool isSynced;

  DatabaseProfile(
      {required this.id,
      required this.userId,
      required this.profilePic,
      required this.name,
      required this.teleHandle,
      required this.year,
      required this.degree,
      required this.course1,
      required this.course2,
      required this.course3,
      required this.hobby1,
      required this.hobby2,
      required this.hobby3,
      required this.isSynced});

  DatabaseProfile.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[idColumn] as int,
        profilePic = map[profilePicColumn] as File,
        name = map[nameColumn] as String,
        teleHandle = map[teleHandleColumn] as String,
        year = map[teleHandleColumn] as int,
        degree = map[degreeColumn] as String,
        course1 = map[course1Column] as String,
        course2 = map[course2Column] as String,
        course3 = map[course3Column] as String,
        hobby1 = map[hobby1Column] as String,
        hobby2 = map[hobby2Column] as String,
        hobby3 = map[hobby3Column] as String,
        isSynced = (map[isSyncedColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      "Profile, ID = $id, userId = $userId, profilePic = $profilePic, name = $name, teleHandle = $teleHandle, year = $year, degree = $degree, course1 = $course1, course2 = $course2, course3 = $course3, hobby1 = $hobby1, hobby2 = $hobby2, hobby3 = $hobby3, isSynced = $isSynced";

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = "profileDB.db";
const profileTable = "profile";
const userTable = "user";
const idColumn = "id";
const emailColumn = "email";
const userIdColumn = "user_id";
const profilePicColumn = "profile_pic";
const nameColumn = "name";
const teleHandleColumn = "tele_handle";
const yearColumn = "year";
const degreeColumn = "degree";
const course1Column = "course1";
const course2Column = "course2";
const course3Column = "course3";
const hobby1Column = "hobby1";
const hobby2Column = "hobby2";
const hobby3Column = "hobby3";
const isSyncedColumn = "is_synced";
const createUserTable = """ CREATE TABLE IF NOT EXISTS "user" (
        "id"	INTEGER NOT NULL,
        "email"	TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
        );""";
const createProfileTable = """ CREATE TABLE "profile" (
        "id"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        "profile_pic"	BLOB,
        "name"	TEXT,
        "tele_handle"	TEXT,
        "year"	INTEGER,
        "degree"	TEXT,
        "course1"	TEXT,
        "course2"	TEXT,
        "course3"	TEXT,
        "hobby1"	TEXT,
        "hobby2"	TEXT,
        "hobby3"	TEXT,
        "is_synced"	INTEGER DEFAULT 0,
        FOREIGN KEY("user_id") REFERENCES "user"("id"),
        PRIMARY KEY("id" AUTOINCREMENT)
        ); """;
