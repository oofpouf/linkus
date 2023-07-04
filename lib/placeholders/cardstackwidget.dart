import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../view/profile/profile_view.dart';
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
  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    fetchData();
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
  }

  void fetchData() async {
    QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Users').get();
    
    List<Profile> fetchedItems = [];
    
    querySnapshot.docs.forEach((doc) {
      final name = doc['name'];
      const distance = 'rahrah123';
      final imageAsset = doc['profile pic'];

      fetchedItems.add(Profile(name: name, distance: distance, imageAsset: imageAsset));
    });

    setState(() {
      draggableItems = fetchedItems;
    });

  // Use the `draggableItems` list as needed
  }


  void populateData() {
    fetchData();
  }

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor:Color(0xffAA8E63),
    body: Column(
      children: [
        ElevatedButton(
          onPressed: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return ProfileView();
                    },
                  ),
              );
          },
        child: const Text("Go back to profile page"),
        ), 
        Expanded(child: Stack(
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
                            curve:
                                const Interval(0, 0.4, curve: Curves.easeInOut),
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
                      color: Colors.brown,
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
      ]
    )
  );

  }
}