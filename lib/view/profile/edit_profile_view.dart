import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkus/constants/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkus/utilities/show_error_dialogue.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../services/auth/auth_service.dart';
import '../../utilities/profile_ui_functions.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final currentUser = AuthService.firebase().currentUser;

  final _nameController = TextEditingController();
  final _teleHandleController = TextEditingController();
  final _yearController = TextEditingController();
  final _degreeController = TextEditingController();
  final _course1Controller = TextEditingController();
  final _course2Controller = TextEditingController();
  final _course3Controller = TextEditingController();

  String dropdownValue1 = "-- Select a hobby --";
  String dropdownValue2 = "-- Select a hobby --";
  String dropdownValue3 = "-- Select a hobby --";

  File? image;
  UploadTask? uploadTask;

  List<String> listValue = [
    "-- Select a hobby --",
    "Arts and crafts",
    "Board/card games",
    "Cooking/baking",
    "Dancing",
    "Gardening and plants",
    "Meditation/wellness",
    "Outdoor activities (hiking, kayaking etc.)",
    "Partying/clubbing",
    "Pets",
    "Photography",
    "Playing an instrument",
    "Reading",
    "Singing",
    "Sports/fitness",
    "Tech/computers",
    "Traveling",
    "Video gaming",
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _teleHandleController.dispose();
    _yearController.dispose();
    _degreeController.dispose();
    _course1Controller.dispose();
    _course2Controller.dispose();
    _course3Controller.dispose();
    super.dispose();
  }

  Future<void> editProfile() async {
    final usersCollection = FirebaseFirestore.instance.collection("Users");
    final currentUser = AuthService.firebase().currentUser;

    String newName = _nameController.text.trim();
    String newTeleHandle = _teleHandleController.text.trim();
    String newYear = _yearController.text.trim();
    String newDegree = _degreeController.text.trim();
    String newCourse1 = _course1Controller.text.trim();
    String newCourse2 = _course2Controller.text.trim();
    String newCourse3 = _course3Controller.text.trim();
    String newHobby1 = dropdownValue1;
    String newHobby2 = dropdownValue2;
    String newHobby3 = dropdownValue3;
    // include URL string for firebase profile

    if (newName.isNotEmpty) {
      await usersCollection.doc(currentUser!.email).update({'name': newName});
    }
    if (newTeleHandle.isNotEmpty) {
      await usersCollection
          .doc(currentUser!.email)
          .update({'tele handle': newTeleHandle});
    }
    if (newYear.isNotEmpty) {
      await usersCollection.doc(currentUser!.email).update({'year': newYear});
    }
    if (newDegree.isNotEmpty) {
      await usersCollection
          .doc(currentUser!.email)
          .update({'degree': newDegree});
    }
    if (newCourse1.isNotEmpty) {
      await usersCollection
          .doc(currentUser!.email)
          .update({'course 1': newCourse1});
    }
    if (newCourse2.isNotEmpty) {
      await usersCollection
          .doc(currentUser!.email)
          .update({'course 2': newCourse2});
    }
    if (newCourse3.isNotEmpty) {
      await usersCollection
          .doc(currentUser!.email)
          .update({'course 3': newCourse3});
    }
    if (newHobby1 != "-- Select a hobby --") {
      await usersCollection
          .doc(currentUser!.email)
          .update({'hobby 1': newHobby1});
    }
    if (newHobby2 != "-- Select a hobby --") {
      await usersCollection
          .doc(currentUser!.email)
          .update({'hobby 2': newHobby2});
    }
    if (newHobby3 != "-- Select a hobby --") {
      await usersCollection
          .doc(currentUser!.email)
          .update({'hobby 3': newHobby3});
    }

    if (image != null) {
      String picUrl = await uploadImage();
      await usersCollection
          .doc(currentUser!.email)
          .update({'profile pic': picUrl});
    }

    // need to check if the profile thing is empty. If not empty can call uploadImage() to upload it onto flutter
    // uploadImage();
    //
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imagePermanent = await saveImagePermanently(image.path);
      setState(() => this.image = imagePermanent);
    } on PlatformException {
      await showErrorDialog(this.context, 'Failed to select image');
    }
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }

  Future<String> uploadImage() async {
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'Images/${currentUser!.email}/$uniqueFileName';
    final file = File(image!.path);

    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      uploadTask = null;
    });

    return urlDownload;
  }

  Widget generateTextField(String hint, TextEditingController controller) {
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

  @override
  Widget build(BuildContext context) {
    ProfileUIFunctions userProf = ProfileUIFunctions();
    return Scaffold(
      backgroundColor: const Color(0xffAA8E63),
      appBar: AppBar(
        backgroundColor: const Color(0xffAA8E63),

        // Route to go back to profile
        leading: IconButton(
          onPressed: () async {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(profileRoute, (route) => false);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color.fromARGB(255, 68, 23, 13),
            size: 25,
          ),
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: Color.fromARGB(255, 68, 23, 13),
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Stack(
                children: [
                  // Profile picture
                  image != null // checking if input is null or not
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: SizedBox(
                              width: 170,
                              height: 170,
                              child: Image.file(image!)))
                      : const CircleAvatar(
                          backgroundColor: Color(0xffE6E6E6),
                          radius: 85,
                          child: Icon(Icons.person,
                              color: Color(0xffCCCCCC), size: 100),
                        ),

                  // Gallery icon
                  Positioned(
                    bottom: 0,
                    right: 5,
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color.fromARGB(255, 68, 23, 13),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.photo_album_rounded,
                          size: 25,
                        ),
                        color: const Color.fromARGB(255, 241, 233, 221),
                        onPressed: () => pickImage(),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 45),
              Form(
                child: Column(
                  children: [
                    // Name title
                    userProf.generateEditTitle('Name'),
                    const SizedBox(height: 10.0),

                    // Name textfield
                    generateTextField('name', _nameController),
                    const SizedBox(height: 30),

                    // Telegram handle title
                    userProf.generateEditTitle('Telegram Handle'),
                    const SizedBox(height: 10.0),

                    // Telegram handle textfield
                    generateTextField('tele handle', _teleHandleController),
                    const SizedBox(height: 30),

                    // Year of study title
                    userProf.generateEditTitle('Year of Study (e.g. 1, 2)'),
                    const SizedBox(height: 10.0),

                    // Year of study textfield
                    generateTextField('year of study', _yearController),
                    const SizedBox(height: 30),

                    // Degree title
                    userProf
                        .generateEditTitle('Degree (e.g. Computer Science)'),
                    const SizedBox(height: 10.0),

                    // Degree textfield
                    generateTextField('degree', _degreeController),
                    const SizedBox(height: 30),

                    // Course title
                    userProf
                        .generateEditTitle('Courses (Include 3, e.g. CS1010S)'),
                    const SizedBox(height: 10.0),

                    // Course 1
                    generateTextField('course code', _course1Controller),
                    const SizedBox(height: 10.0),

                    // Course 2
                    generateTextField('course code', _course2Controller),
                    const SizedBox(height: 10.0),

                    // Course 3
                    generateTextField('course code', _course3Controller),
                    const SizedBox(height: 30),

                    // Hobbies title
                    userProf.generateEditTitle('Hobbies (Select up to 3)'),
                    const SizedBox(height: 10.0),

                    // Hobbies drop down 1
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 241, 233, 221),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            padding: const EdgeInsets.only(left: 20.0),
                            value: dropdownValue1,
                            // Step 4.
                            items: listValue
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue1 = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),

                    // Hobbies drop down 2
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 241, 233, 221),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              // Step 3.
                              value: dropdownValue2,
                              // Step 4.
                              items: listValue.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue2 = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),

                    // Hobbies drop down 3
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 241, 233, 221),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              // Step 3.
                              value: dropdownValue3,
                              // Step 4.
                              items: listValue.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue3 = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 45.0),

                    // Update changes button
                    SizedBox(
                      width: 220,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          await editProfile();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              profileRoute, (route) => false);
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
                          "Update Changes",
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}