import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkus/constants/routes.dart';
import 'package:linkus/services/profile/firebase_profile_service.dart';
import 'package:linkus/widgets/profile_functions.dart';

import '../../services/auth/auth_service.dart';
import '../../services/profile/profile_cloud.dart';
import '../../utilities/error_dialogue.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // current user
  final currentUser = AuthService.firebase().currentUser;
  final profiles = FirebaseProfileService();

  @override
  void initState() {
    super.initState();
  }

  // Future<void> refreshProfile() async {
  //   setState(() {
  //     _profileFuture = profiles.fetchProfile(email: currentUser!.email);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            onPressed: () async {
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout) {
                await AuthService.firebase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (_) => false,
                );
              }
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: Color.fromARGB(255, 68, 23, 13),
              size: 30,
            ),
          )
        ],
      ),
      body: StreamBuilder<ProfileCloud>(
          stream: profiles.fetchProfile(email: currentUser!.email),
          builder:
              (BuildContext context, AsyncSnapshot<ProfileCloud> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // If an error occurred during the fetch, display an error message
              showDialog(
                context: this.context,
                builder: (context) {
                  return ErrorDialog(text: 'Error: ${snapshot.error}');
                },
              );
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // Once the profile is fetched, create the ProfileUIFunctions object
              ProfileCloud profile = snapshot.data!;
              ProfileFunctions userProf = ProfileFunctions(profile: profile);
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
                      const SizedBox(height: 15),
                      const Divider(),
                      const SizedBox(height: 15),

                      // Year of study
                      userProf.generateTitle('Year of Study'),
                      const SizedBox(height: 2),

                      // YOS description
                      userProf.generateYear(),
                      const SizedBox(height: 25),

                      // Degree
                      userProf.generateTitle('Degree'),
                      const SizedBox(height: 2),

                      // Degree description
                      userProf.generateDegree(),
                      const SizedBox(height: 25),

                      // Hobbies
                      userProf.generateTitle('Hobbies'),
                      const SizedBox(height: 2),

                      // Hobbies description
                      userProf.generateHobbies(),
                      const SizedBox(height: 40),

                      // Edit profile button
                      SizedBox(
                        width: 220,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pushNamed(editProfileRoute);
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
                                color: Color.fromARGB(255, 241, 233, 221),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  Future<bool> showLogOutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 241, 233, 221),
          title: const Text(
            'Logout',
            style: TextStyle(
              color: Color.fromARGB(255, 63, 50, 30),
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: Color.fromARGB(255, 63, 50, 30),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color.fromARGB(255, 63, 50, 30),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Color.fromARGB(255, 63, 50, 30),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}
