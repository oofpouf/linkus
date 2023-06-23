import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileUIFunctions {
  final File? profilePic;
  final String name;
  final String teleHandle;

  ProfileUIFunctions({
    required this.profilePic,
    required this.name,
    required this.teleHandle,
  });

  // pfp
  Widget generatePfp() {
    return SizedBox(
      width: 170,
      height: 170,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: profilePic != null // checking if input is null or not
            ? Image.file(profilePic!)
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
      name,
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
      teleHandle,
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
}
