import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkus/services/profile/profile_cloud.dart';

class ProfileFunctions {
  final ProfileCloud profile;

  const ProfileFunctions({required this.profile});

  //pfp
  Widget generatePfp() {
    return SizedBox(
      width: 170,
      height: 170,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: profile.profilePic != "" // checking if input is null or not
            ? Image.network(
                profile.profilePic,
                fit: BoxFit.cover,
                key: const Key('profile_pic'),
              )
            : const CircleAvatar(
                backgroundColor: Color(0xffE6E6E6),
                radius: 10,
                child: Icon(Icons.person, color: Color(0xffCCCCCC), size: 100),
              ),
      ),
    );
  }

  // name
  Text generateName() {
    return Text(
      profile.name,
      style: GoogleFonts.comfortaa(
        textStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: Color.fromARGB(255, 68, 23, 13),
        ),
      ),
    );
  }

  // telehandle
  Text generateTeleHandle() {
    return Text(
      profile.teleHandle,
      style: GoogleFonts.comfortaa(
        textStyle: const TextStyle(fontSize: 16),
        color: const Color.fromARGB(255, 241, 233, 221),
      ),
    );
  }

  // title
  Widget generateTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child:
          // Year of study
          Text(
        title,
        style: GoogleFonts.comfortaa(
          textStyle: const TextStyle(
            color: Color.fromARGB(255, 68, 23, 13),
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget generateEditTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.comfortaa(
            textStyle: const TextStyle(
              color: Color.fromARGB(255, 68, 23, 13),
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  // body text
  Widget generateBodyText(String bodyText) {
    return // Year of study description
        Align(
      alignment: Alignment.centerLeft,
      child: Text(
        bodyText,
        style: GoogleFonts.comfortaa(
          textStyle: const TextStyle(
            color: Color.fromARGB(255, 241, 233, 221),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget generateYear() {
    return generateBodyText(profile.year);
  }

  Widget generateDegree() {
    return generateBodyText(profile.degree);
  }

  Widget generateHobbies() {
    return generateBodyText('${profile.hobby1}, ${profile.hobby2}, ${profile.hobby3}');
  }

  Widget generateTextField(String hint, String key, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 241, 233, 221),
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: TextFormField(
            key: Key(key),
            controller: controller,
            enableSuggestions: false,
            autocorrect: false,
            cursorColor: const Color.fromARGB(255, 68, 23, 13),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter your $hint here",
            ),
          ),
        ),
      ),
    );
  }

  Widget generateNumField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 241, 233, 221),
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: TextFormField(
            key: const Key('year_field'),
            controller: controller,
            enableSuggestions: false,
            autocorrect: false,
            cursorColor: const Color.fromARGB(255, 68, 23, 13),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter your $hint here",
            ),
          ),
        ),
      ),
    );
  }
}
