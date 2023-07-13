import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkus/constants/routes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkus/services/profile/firebase_profile_storage.dart';
import 'package:linkus/services/profile/profile_exceptions.dart';
import 'package:linkus/utilities/show_error_dialogue.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../services/auth/auth_service.dart';
import '../../services/profile/profile_cloud.dart';
import '../../widgets/profile_functions.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final currentUser = AuthService.firebase().currentUser;
  final profiles = FirebaseProfileStorage();
  late Future<ProfileCloud> future;

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
    "arts and crafts",
    "board/card games",
    "cooking/baking",
    "dancing",
    "gardening and plants",
    "meditation/wellness",
    "outdoor activities",
    "partying/clubbing",
    "pets",
    "photography",
    "playing an instrument",
    "reading",
    "singing",
    "sports/fitness",
    "tech/computers",
    "traveling",
    "video gaming",
  ];

  @override
  void initState() {
    super.initState();
    future = profiles.fetchProfile(email: currentUser!.email);
  }

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
    String newName = _nameController.text.trim();
    String newTeleHandle = _teleHandleController.text.trim();
    String newYear = _yearController.text.trim();
    String newDegree = _degreeController.text.trim().toLowerCase();
    String newCourse1 =
        _course1Controller.text.replaceAll(' ', '').toLowerCase();
    String newCourse2 =
        _course2Controller.text.replaceAll(' ', '').toLowerCase();
    String newCourse3 =
        _course3Controller.text.replaceAll(' ', '').toLowerCase();
    String newHobby1 = dropdownValue1;
    String newHobby2 = dropdownValue2;
    String newHobby3 = dropdownValue3;
    // include URL string for firebase profile

    if (newName.isEmpty ||
        newTeleHandle.isEmpty ||
        newYear.isEmpty ||
        newDegree.isEmpty ||
        newCourse1.isEmpty ||
        newCourse2.isEmpty ||
        newCourse3.isEmpty ||
        newHobby1 == "-- Select a hobby --" ||
        newHobby2 == "-- Select a hobby --" ||
        newHobby3 == "-- Select a hobby --") {
      throw EmptyFieldException();
    } else if (newYear != "1" &&
        newYear != "2" &&
        newYear != "3" &&
        newYear != "4" &&
        newYear != "5") {
      throw InvalidYearException();
    } else if (newCourse1 == newCourse2 ||
        newCourse2 == newCourse3 ||
        newCourse3 == newCourse1) {
      throw RepeatedCourseException();
    } else if (newHobby1 == newHobby2 ||
        newHobby2 == newHobby3 ||
        newHobby3 == newHobby1) {
      throw RepeatedHobbyException();
    }

    if (image != null) {
      String picUrl = await uploadImage();
      profiles.updateProfile(
          profilePic: picUrl,
          email: currentUser!.email,
          name: newName,
          teleHandle: newTeleHandle,
          year: newYear,
          degree: newDegree,
          course1: newCourse1,
          course2: newCourse2,
          course3: newCourse3,
          hobby1: newHobby1,
          hobby2: newHobby2,
          hobby3: newHobby3);
    } else {
      profiles.updateProfile(
          email: currentUser!.email,
          name: newName,
          teleHandle: newTeleHandle,
          year: newYear,
          degree: newDegree,
          course1: newCourse1,
          course2: newCourse2,
          course3: newCourse3,
          hobby1: newHobby1,
          hobby2: newHobby2,
          hobby3: newHobby3);
    }

    // await usersCollection.doc(currentUser!.email).update({'name': newName});

    // await usersCollection
    //     .doc(currentUser!.email)
    //     .update({'tele handle': newTeleHandle});

    // await usersCollection.doc(currentUser!.email).update({'year': newYear});

    // await usersCollection.doc(currentUser!.email).update({'degree': newDegree});

    // await usersCollection
    //     .doc(currentUser!.email)
    //     .update({'course 1': newCourse1});

    // await usersCollection
    //     .doc(currentUser!.email)
    //     .update({'course 2': newCourse2});

    // await usersCollection
    //     .doc(currentUser!.email)
    //     .update({'course 3': newCourse3});

    // await usersCollection
    //     .doc(currentUser!.email)
    //     .update({'hobby 1': newHobby1});

    // await usersCollection
    //     .doc(currentUser!.email)
    //     .update({'hobby 2': newHobby2});

    // await usersCollection
    //     .doc(currentUser!.email)
    //     .update({'hobby 3': newHobby3});
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

  Future<bool> showReturnDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 241, 233, 221),
          title: const Text(
            'Return',
            style: TextStyle(
              color: Color.fromARGB(255, 63, 50, 30),
            ),
          ),
          content: const Text(
            'Do you want to return? Your changes will not be saved',
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
                'Return',
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

  SingleChildScrollView buildProfileContent(ProfileFunctions userProf) {
    return SingleChildScrollView(
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
                            child: Image.file(image!, fit: BoxFit.cover)))
                    : userProf.generatePfp(),
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
                  userProf.generateTextField('name', _nameController),
                  const SizedBox(height: 30),

                  // Telegram handle title
                  userProf.generateEditTitle('Telegram Handle'),
                  const SizedBox(height: 10.0),

                  // Telegram handle textfield
                  userProf.generateTextField(
                      'tele handle', _teleHandleController),
                  const SizedBox(height: 30),

                  // Year of study title
                  userProf.generateEditTitle('Year of Study (e.g. 1, 2)'),
                  const SizedBox(height: 10.0),

                  // Year of study textfield
                  userProf.generateNumField('year of study', _yearController),
                  const SizedBox(height: 30),

                  // Degree title
                  userProf.generateEditTitle('Degree (e.g. Computer Science)'),
                  const SizedBox(height: 10.0),

                  // Degree textfield
                  userProf.generateTextField('degree', _degreeController),
                  const SizedBox(height: 30),

                  // Course title
                  userProf.generateEditTitle('Courses (Include 3)'),
                  const SizedBox(height: 10.0),

                  // Course 1
                  userProf.generateTextField('course code', _course1Controller),
                  const SizedBox(height: 10.0),

                  // Course 2
                  userProf.generateTextField('course code', _course2Controller),
                  const SizedBox(height: 10.0),

                  // Course 3
                  userProf.generateTextField('course code', _course3Controller),
                  const SizedBox(height: 30),

                  // Hobbies title
                  userProf.generateEditTitle('Hobbies (Select 3)'),
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
                      width: 370,
                      height: 50,
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
                      width: 370,
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            // Step 3.
                            value: dropdownValue2,
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
                      width: 370,
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            // Step 3.
                            value: dropdownValue3,
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
                        try {
                          await editProfile();
                          Navigator.of(this.context).pushNamedAndRemoveUntil(
                              myNavigationBarRoute, (route) => false);
                        } on EmptyFieldException {
                          showErrorDialog(
                              this.context, "Please complete all fields");
                        } on RepeatedCourseException {
                          showErrorDialog(this.context,
                              "Please ensure there are no repeated courses");
                        } on RepeatedHobbyException {
                          showErrorDialog(this.context,
                              "Please ensure there are no repeated hobbies");
                        } on InvalidYearException {
                          showErrorDialog(
                              this.context, "Please input a vaid year (1-5)");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 68, 23, 13),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffAA8E63),
      appBar: AppBar(
        backgroundColor: const Color(0xffAA8E63),

        // Route to go back to profile
        leading: IconButton(
          onPressed: () async {
            // check if user is new
            try {
              ProfileCloud profile =
                  await profiles.fetchProfile(email: currentUser!.email);
              if (profile.hasEmptyFields()) {
                throw NoProfileException();
              }

              final shouldReturn = await showReturnDialog(context);
              if (shouldReturn) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    myNavigationBarRoute, (route) => false);
              }
            } on NoProfileException {
              showErrorDialog(
                  this.context, "Please create a profile before proceeding");
            }
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
      body: FutureBuilder<ProfileCloud>(
          future: future,
          builder:
              (BuildContext context, AsyncSnapshot<ProfileCloud> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              showErrorDialog(this.context, 'Error${snapshot.error}');
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              ProfileCloud profile = snapshot.data!;
              ProfileFunctions userProf = ProfileFunctions(profile: profile);

              return buildProfileContent(userProf);
            }
          }),
    );
  }
}
