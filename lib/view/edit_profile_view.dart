import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkus/constants/routes.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  List<TextEditingController> listController = [TextEditingController()];
  String dropdownValue1 = "-- Select a hobby --";
  String dropdownValue2 = "-- Select a hobby --";
  String dropdownValue3 = "-- Select a hobby --";

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
  Widget build(BuildContext context) {
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
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child:
                            const Image(image: AssetImage('lib/icons/ai.jpg'))),
                  ),
                  const SizedBox(height: 15),

                  // Camera icon
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
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Color.fromARGB(255, 241, 233, 221),
                        size: 25,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Name",
                          style: GoogleFonts.comfortaa(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 68, 23, 13),
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),

                    // Name textfield
                    Padding(
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
                            enableSuggestions: false,
                            autocorrect: false,
                            cursorColor: const Color.fromARGB(255, 68, 23, 13),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your name here',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Telegram handle title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Telegram Handle",
                          style: GoogleFonts.comfortaa(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 68, 23, 13),
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),

                    // Telegram handle textfield
                    Padding(
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
                            enableSuggestions: false,
                            autocorrect: false,
                            cursorColor: const Color.fromARGB(255, 68, 23, 13),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your telegram handle here',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Year of study title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Year of Study",
                          style: GoogleFonts.comfortaa(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 68, 23, 13),
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),

                    // Year of study textfield
                    Padding(
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
                            enableSuggestions: false,
                            autocorrect: false,
                            cursorColor: const Color.fromARGB(255, 68, 23, 13),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your year of study here',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Degree title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Degree",
                          style: GoogleFonts.comfortaa(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 68, 23, 13),
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),

                    // Degree textfield
                    Padding(
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
                            enableSuggestions: false,
                            autocorrect: false,
                            cursorColor: const Color.fromARGB(255, 68, 23, 13),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your degree here',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Course title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Courses (Add Up to 3)",
                          style: GoogleFonts.comfortaa(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 68, 23, 13),
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Course drop down
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shrinkWrap: true,
                      itemCount:
                          listController.length < 3 ? listController.length : 3,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 241, 233, 221),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: TextFormField(
                                      controller: listController[index],
                                      autofocus: false,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Enter your course code here",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 0,
                              ),
                              index > 0
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          listController[index].clear();
                                          listController[index].dispose();
                                          listController.removeAt(index);
                                        });
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: Color.fromARGB(255, 68, 23, 13),
                                        size: 35,
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    // Add more button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          listController.add(TextEditingController());
                        });
                      },
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 241, 233, 221)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text("+ Add More",
                              style: GoogleFonts.comfortaa(
                                color: const Color.fromARGB(255, 241, 233, 221),
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const SizedBox(height: 30),

                    // Hobbies title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Hobbies (Select Up to 3)",
                          style: GoogleFonts.comfortaa(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 68, 23, 13),
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
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
                        onPressed: () {},
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
