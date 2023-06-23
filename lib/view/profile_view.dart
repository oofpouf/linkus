import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkus/constants/routes.dart';
import 'package:linkus/utilities/profile_ui_functions.dart';

import '../services/auth/auth_service.dart';
import '../services/crud/profile_service.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final ProfileService _profileService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _profileService = ProfileService();
    _profileService.open();
    super.initState();
  }

  @override
  void dispose() {
    _profileService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProfileUIFunctions userProf = ProfileUIFunctions(
        profilePic: null, name: "[Name]", teleHandle: "[TeleHandle']");
    return Scaffold(
      backgroundColor: const Color(0xffAA8E63),
      appBar: AppBar(
        backgroundColor: const Color(0xffAA8E63),
        title: Text(
          'Profile',
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: Color.fromARGB(255, 68, 23, 13),
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _profileService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                  stream: _profileService.allProfiles,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting: // for empty profile
                        return SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                // Profile picture
                                userProf.generatePfp(),
                                const SizedBox(height: 20),

                                // User name
                                userProf.generateName(),

                                // Tele handle
                                userProf.generateTeleHandle(),
                                const SizedBox(height: 20),
                                const Divider(),
                                const SizedBox(height: 20),

                                // Year of study
                                userProf
                                    .generateTitle('Year of Study (e.g. 1, 2)'),
                                const SizedBox(height: 2),

                                // YOS description
                                userProf.generateBodyText('[Year]'),
                                const SizedBox(height: 25),

                                // Degree
                                userProf.generateTitle(
                                    'Degree (e.g. Computer Science)'),
                                const SizedBox(height: 2),

                                // Degree description
                                userProf.generateBodyText('[Degree]'),
                                const SizedBox(height: 25),

                                // Courses
                                userProf
                                    .generateTitle('Courses (e.g. CS1010S)'),
                                const SizedBox(height: 2),

                                // Courses description
                                userProf.generateBodyText('[Courses]'),
                                const SizedBox(height: 25),

                                // Hobbies
                                userProf.generateTitle('Hobbies'),
                                const SizedBox(height: 2),

                                // Hobbies description
                                userProf.generateBodyText('[Hobbies]'),
                                const SizedBox(height: 25),

                                const SizedBox(height: 45),

                                // Edit profile button
                                SizedBox(
                                  width: 220,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      Navigator.of(context)
                                          .pushNamed(editProfileRoute);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 68, 23, 13),
                                      side: BorderSide.none,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      "Edit Profile",
                                      style: GoogleFonts.comfortaa(
                                        textStyle: const TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              255, 241, 233, 221),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      default:
                        return const CircularProgressIndicator();
                    }
                  });
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
