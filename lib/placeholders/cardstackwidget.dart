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

  List<Profile> draggableItems = [];

  Future<List<Profile>> fetchData() async {
    final currentEmail = FirebaseAuth.instance.currentUser?.email;   
    QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Users').get();

    List<Profile> items = [];

    DocumentSnapshot? currentUser;
    
    for(var doc in querySnapshot.docs) {
      if (doc.id == currentEmail) {
        currentUser = doc;
        break;
      }
    }

    if(currentUser != null) {
      String criteria = '';
      final userCourse = currentUser['degree'];
      final userHobby1 = currentUser['hobby 1'];
      final userHobby2 = currentUser['hobby 2'];
      final userHobby3 = currentUser['hobby 3'];
      querySnapshot.docs.forEach((doc) {
        final name = doc['name'];
        final imageAsset = doc['profile pic'];
        final course = doc['degree'];
        final hobby1 = doc['hobby 1'];
        final hobby2 = doc['hobby 2'];
        final hobby3 = doc['hobby 3'];

        if(userCourse == course) {
          criteria = userCourse;
        } else if (userHobby1 == hobby1 || userHobby1 == hobby2 || userHobby1 == hobby3) {
          criteria = userHobby1;
        } else if (userHobby2 == hobby1 || userHobby2 == hobby2 || userHobby2 == hobby3) {
          criteria = userHobby2;
        } else if (userHobby3 == hobby1 || userHobby3 == hobby2 || userHobby3 == hobby3) {
          criteria = userHobby3;
        } else {
          criteria = '';
        }

        if (doc.id != currentEmail && criteria != '') {
          final distance = criteria;
          items.add(Profile(name: name, distance: distance, imageAsset: imageAsset));
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
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pushNamedAndRemoveUntil(
                        myNavigationBarRoute, (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 241, 233, 221),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Return to profile page",
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
                              ),
                            ),
                          );
                        } else {
                          return DragWidget(
                            profile: draggableItems[index],
                            index: index,
                            swipeNotifier: swipeNotifier,
                          );
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
                          onPressed: () {
                            swipeNotifier.value = Swipe.left;
                            _animationController.forward();
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 20),
                        ActionButtonWidget(
                          onPressed: () {
                            swipeNotifier.value = Swipe.right;
                            _animationController.forward();
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
              ],
            ),
          )
        ]));
  }
}