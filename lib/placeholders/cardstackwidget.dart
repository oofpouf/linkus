import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/routes.dart';
import 'actionwidget.dart';
import 'dragwidget.dart';
import 'profile.dart';

class CardsStackWidget extends StatefulWidget {
  const CardsStackWidget({Key? key}) : super(key: key);

  @override
  State<CardsStackWidget> createState() => _CardsStackWidgetState();
}

class _CardsStackWidgetState extends State<CardsStackWidget>
    with SingleTickerProviderStateMixin {
  final currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
  List<Profile> draggableItems = [];
  List<Profile> matchedProfiles = [];
  List<String> emails = [];
  List<String> matchEmails = [];
  List<String> likedProfiles = [];
  bool profilesAvailable = true;
  List<String> dislikedProfiles = [];

  Future<List<Profile>> fetchData() async {
    final currentEmail = FirebaseAuth.instance.currentUser?.email;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Users').get();

    List<Profile> items = [];

    DocumentSnapshot? currentUser;

    for (var doc in querySnapshot.docs) {
      if (doc.id == currentEmail) {
        currentUser = doc;
        break;
      }
    }

    if (currentUser != null) {
      String criteria = '';
      final userCourse = currentUser['degree'];
      final userHobby1 = currentUser['hobby 1'];
      final userHobby2 = currentUser['hobby 2'];
      final userHobby3 = currentUser['hobby 3'];
      final year = currentUser['year'];

      querySnapshot.docs.forEach((doc) {
        final name = doc['name'];
        final imageAsset = doc['profile pic'];
        final course = doc['degree'];
        final hobby1 = doc['hobby 1'];
        final hobby2 = doc['hobby 2'];
        final hobby3 = doc['hobby 3'];

        if (userCourse == course) {
          criteria = userCourse;
        } else if (userHobby1 == hobby1 ||
            userHobby1 == hobby2 ||
            userHobby1 == hobby3) {
          criteria = userHobby1;
        } else if (userHobby2 == hobby1 ||
            userHobby2 == hobby2 ||
            userHobby2 == hobby3) {
          criteria = userHobby2;
        } else if (userHobby3 == hobby1 ||
            userHobby3 == hobby2 ||
            userHobby3 == hobby3) {
          criteria = userHobby3;
        } else {
          criteria = '';
        }

        if (doc.id != currentEmail &&
            criteria != '' &&
            !matchEmails.contains(doc.id) &&
            !likedProfiles.contains(doc.id) &&
            !dislikedProfiles.contains(doc.id)) {
          final distance = criteria;
          items.add(Profile(
              year: year,
              name: name,
              distance: distance,
              imageAsset: imageAsset,
              email: doc.id));
        }
      });
    }

    return items;

    // Use the `draggableItems` list as needed
  }

  void populateData() async {
    List<Profile> items = await fetchData();
    setState(() {
      draggableItems = items;
      profilesAvailable = draggableItems.isNotEmpty;
    });
  }

  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        draggableItems.removeLast();
        _animationController.reset();

        swipeNotifier.value = Swipe.none;
      }
    });
    populateData();
    processLikes();
    processMatches();
    filterLikes();
    processDislikes();
  }

  @override
  void dispose() {
    _animationController
        .dispose(); // Dispose of the AnimationController and its associated Ticker.
    super.dispose();
  }

  void onMatched(Profile profile) {
    setState(() {
      matchedProfiles.add(profile);
    });
    // Perform any other actions you need for a match
  }

  //updating firebase of loggedin user by adding disliked profiles into the dislikes field
  Future<void> updateDislikes(Profile profile) async {
    final usersCollection = FirebaseFirestore.instance.collection('Users');
    final profileDoc = usersCollection.doc(currentUserEmail);

    try {
      final snapshot = await profileDoc.get();

      if (snapshot.exists) {
        final likes = List<String>.from(snapshot.data()?['disliked profiles'] ?? []);
        if (!likes.contains(profile.email)) {
          likes.add(profile.email);
          await profileDoc.update({'disliked profiles': likes});
        }
      }
    } catch (error) {
      debugPrint('Error updating likes: $error');
    }
  }

  Future<List<dynamic>> getDislikedProfiles() async {
    final usersCollection = FirebaseFirestore.instance.collection('Users');
    final userDoc = usersCollection.doc(currentUserEmail);

    try {
      final snapshot = await userDoc.get();
      if (snapshot.exists) {
        final dislikes = snapshot.data()?['disliked profiles'];
        return dislikes != null ? List<dynamic>.from(dislikes) : [];
      }
    } catch (error) {
      debugPrint('Error retrieving likes: $error');
    }

    return [];
  }

  Future<void> processDislikes() async {
    List<dynamic> dislikes = await getDislikedProfiles();
    dislikedProfiles = List<String>.from(dislikes);
  }

  //updating firebase of loggedin user by adding the profiles that logged in user has liked for filtering.
  Future<void> updateLikes(Profile profile) async {
    final usersCollection = FirebaseFirestore.instance.collection('Users');
    final profileDoc = usersCollection.doc(currentUserEmail);

    try {
      final snapshot = await profileDoc.get();

      if (snapshot.exists) {
        final likes = List<String>.from(snapshot.data()?['liked profiles'] ?? []);
        if (!likes.contains(profile.email)) {
          likes.add(profile.email);
          await profileDoc.update({'liked profiles': likes});
        }
      }
    } catch (error) {
      debugPrint('Error updating likes: $error');
    }
  }



  Future<void> filterLikes() async {
    List<dynamic> likes = await getLikedProfiles();
    likedProfiles = List<String>.from(likes);
  }

  Future<List<dynamic>> getLikedProfiles() async {
    final usersCollection = FirebaseFirestore.instance.collection('Users');
    final userDoc = usersCollection.doc(currentUserEmail);

    try {
      final snapshot = await userDoc.get();
      if (snapshot.exists) {
        final likes = snapshot.data()?['liked profiles'];
        return likes != null ? List<dynamic>.from(likes) : [];
      }
    } catch (error) {
      debugPrint('Error retrieving likes: $error');
    }

    return [];
  }

  //fetching the users that have liked current user
  Future<List<dynamic>> getLikes() async {
    final usersCollection = FirebaseFirestore.instance.collection('Users');
    final userDoc = usersCollection.doc(currentUserEmail);

    try {
      final snapshot = await userDoc.get();
      if (snapshot.exists) {
        final likes = snapshot.data()?['likes'];
        return likes != null ? List<dynamic>.from(likes) : [];
      }
    } catch (error) {
      debugPrint('Error retrieving likes: $error');
    }

    return [];
  }
  

  //related to likes
  Future<void> processLikes() async {
    List<dynamic> likes = await getLikes();
    emails = List<String>.from(likes);
  }

  //fetching users that have matched with current user.
  Future<List<dynamic>> getMatches() async {
    final usersCollection = FirebaseFirestore.instance.collection('Users');
    final userDoc = usersCollection.doc(currentUserEmail);

    try {
      final snapshot = await userDoc.get();
      if (snapshot.exists) {
        final matches = snapshot.data()?['matches'];
        return matches != null ? List<dynamic>.from(matches) : [];
      }
    } catch (error) {
      debugPrint('Error retrieving matches: $error');
    }

    return [];
  }

  Future<void> processMatches() async {
    List<dynamic> matches = await getMatches();
    setState(() {
      matchEmails = List<String>.from(matches);
    });
  }

  //update firebase upon clicking like button and fetch the likes list from firebase
  Future<List<String>> addToLikes(Profile profile) async {
    final usersCollection = FirebaseFirestore.instance.collection('Users');
    final profileDoc = usersCollection.doc(profile.email);

    try {
      final snapshot = await profileDoc.get();

      if (snapshot.exists) {
        final likes = List<String>.from(snapshot.data()?['likes'] ?? []);
        if (!likes.contains(currentUserEmail)) {
          likes.add(currentUserEmail);
          await profileDoc.update({'likes': likes});
        }
        return likes; // Return the updated likes list
      }
    } catch (error) {
      debugPrint('Error updating likes: $error');
    }

    return []; // Return an empty list if update fails
  }

  bool checkForMatch(List<String> list, Profile profile) {
    bool isMatch =
        list.contains(currentUserEmail) && emails.contains(profile.email);

    if (isMatch) {
      // Update the 'matches' field for the logged-in user
      FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserEmail)
          .update({
        'matches': FieldValue.arrayUnion([profile.email])
      }).catchError((error) {
        debugPrint('Error updating matches: $error');
      });

      FirebaseFirestore.instance.collection('Users').doc(profile.email).update({
        'matches': FieldValue.arrayUnion([currentUserEmail])
      }).catchError((error) {
        debugPrint('Error updating matches: $error');
      });
    }

    return isMatch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffAA8E63),
        body: Column(children: [
          const SizedBox(height: 70),
          SizedBox(
            width: 220,
            height: 40,
            child: ElevatedButton(
              key: const Key('return_button'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pushNamedAndRemoveUntil(
                        matchHistoryRoute, (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 241, 233, 221),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Return to link history",
                style: GoogleFonts.comfortaa(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 68, 23, 13),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ValueListenableBuilder(
                    valueListenable: swipeNotifier,
                    builder: (context, swipe, _) => Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: List.generate(draggableItems.length, (index) {
                        if (index == draggableItems.length - 1) {
                          return PositionedTransition(
                            rect: RelativeRectTween(
                              begin: RelativeRect.fromSize(
                                  const Rect.fromLTWH(0, 0, 580, 340),
                                  const Size(580, 340)),
                              end: RelativeRect.fromSize(
                                  Rect.fromLTWH(
                                      swipe != Swipe.none
                                          ? swipe == Swipe.left
                                              ? -300
                                              : 300
                                          : 0,
                                      0,
                                      580,
                                      340),
                                  const Size(580, 340)),
                            ).animate(CurvedAnimation(
                              parent: _animationController,
                              curve: Curves.easeInOut,
                            )),
                            child: RotationTransition(
                              turns: Tween<double>(
                                      begin: 0,
                                      end: swipe != Swipe.none
                                          ? swipe == Swipe.left
                                              ? -0.1 * 0.3
                                              : 0.1 * 0.3
                                          : 0.0)
                                  .animate(
                                CurvedAnimation(
                                  parent: _animationController,
                                  curve: const Interval(0, 0.4,
                                      curve: Curves.easeInOut),
                                ),
                              ),
                              child: DragWidget(
                                  profile: draggableItems[index],
                                  index: index,
                                  swipeNotifier: swipeNotifier,
                                  isLastCard: true,
                                  onMatched: onMatched),
                            ),
                          );
                        } else {
                          return DragWidget(
                              profile: draggableItems[index],
                              index: index,
                              swipeNotifier: swipeNotifier,
                              onMatched: onMatched);
                        }
                      }),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 46.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ActionButtonWidget(
                          onPressed: () async {
                            swipeNotifier.value = Swipe.left;
                            _animationController.forward();
                            Profile swipedProfile = draggableItems.last;
                            await updateDislikes(swipedProfile);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 20),
                        ActionButtonWidget(
                          onPressed: () async {
                            swipeNotifier.value = Swipe.right;
                            _animationController.forward();
                            Profile swipedProfile = draggableItems.last;

                            List<String> updatedLikes =
                                await addToLikes(swipedProfile);
                            await updateLikes(swipedProfile);
                            if (checkForMatch(updatedLikes, swipedProfile)) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    key: Key('link_dialog'),
                                    title: const Text('It\'s a Link!'),
                                    content: Text(
                                      'You and ${swipedProfile.name} have liked each other!',
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );

                            }
                          },
                          icon: const Icon(
                            Icons.favorite,
                            color: Color.fromARGB(255, 68, 23, 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  child: DragTarget<int>(
                    builder: (
                      BuildContext context,
                      List<dynamic> accepted,
                      List<dynamic> rejected,
                    ) {
                      return IgnorePointer(
                        child: Container(
                          height: 700.0,
                          width: 80.0,
                          color: Colors.transparent,
                        ),
                      );
                    },
                    onAccept: (int index) {
                      setState(() {
                        draggableItems.removeAt(index);
                      });
                    },
                  ),
                ),
                Positioned(
                  right: 0,
                  child: DragTarget<int>(
                    builder: (
                      BuildContext context,
                      List<dynamic> accepted,
                      List<dynamic> rejected,
                    ) {
                      return IgnorePointer(
                        child: Container(
                          height: 700.0,
                          width: 80.0,
                          color: Colors.transparent,
                        ),
                      );
                    },
                    onAccept: (int index) {
                      setState(() {
                        draggableItems.removeAt(index);
                      });
                    },
                  ),
                ),
                if (!profilesAvailable)
                  Center(
                    child: Text(
                      "There are no available profiles to swipe",
                      style: GoogleFonts.comfortaa(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          )
        ]));
  }
}
