import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'profile.dart';
import 'profilecard.dart';

enum Swipe { left, right, none }

class DragWidget extends StatefulWidget {
  const DragWidget({
    Key? key,
    required this.profile,
    required this.index,
    required this.swipeNotifier,
    this.isLastCard = false,
    required this.onMatched,
  }) : super(key: key);
  
  final Profile profile;
  final int index;
  final ValueNotifier<Swipe> swipeNotifier;
  final bool isLastCard;
  final Function(Profile) onMatched;

  @override
  State<DragWidget> createState() => _DragWidgetState();
}

class _DragWidgetState extends State<DragWidget> {
  bool isLiked = false;
  final currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
  List<String> emails = [];
  double totalDragDistance = 0;

  @override
  void initState() {
    super.initState();
    processLikes();
  }

  
  @override
  Widget build(BuildContext context) {
    Profile profile = widget.profile;
    return Center(
      child: Draggable<int>(
        // Data is the value this Draggable stores.
        data: widget.index,
        feedback: Material(
          color: Colors.transparent,
          child: ValueListenableBuilder(
            valueListenable: widget.swipeNotifier,
            builder: (context, swipe, _) {
              return RotationTransition(
                turns: widget.swipeNotifier.value != Swipe.none
                    ? widget.swipeNotifier.value == Swipe.left
                        ? const AlwaysStoppedAnimation(-15 / 360)
                        : const AlwaysStoppedAnimation(15 / 360)
                    : const AlwaysStoppedAnimation(0),
                child: Stack(
                  children: [
                    ProfileCard(profile: widget.profile),
                    widget.swipeNotifier.value != Swipe.none
                        ? widget.swipeNotifier.value == Swipe.right
                            ? Positioned(
                                top: 40,
                                left: 20,
                                child: Transform.rotate(
                                  angle: 12,
                                  child: TagWidget(
                                    text: "LIKE",
                                    color: Colors.green[400]!,
                                  ),
                                ),
                              )
                            : Positioned(
                                top: 50,
                                right: 24,
                                child: Transform.rotate(
                                  angle: -12,
                                  child: TagWidget(
                                    text: 'DISLIKE',
                                    color: Colors.red[400]!,
                                  ),
                                ),
                              )
                        : const SizedBox.shrink(),
                  ],
                ),
              );
            },
          ),
        ),
        onDragUpdate: (DragUpdateDetails dragUpdateDetails) {
          if (dragUpdateDetails.delta.dx > 0 &&
              dragUpdateDetails.globalPosition.dx >
                  MediaQuery.of(context).size.width / 2) {
            widget.swipeNotifier.value = Swipe.right;
            totalDragDistance += dragUpdateDetails.delta.dx;
          }
          if (dragUpdateDetails.delta.dx < 0 &&
              dragUpdateDetails.globalPosition.dx <
                  MediaQuery.of(context).size.width / 2) {
            widget.swipeNotifier.value = Swipe.left;
            totalDragDistance = 0;
          }
          
        },
        onDragEnd: (drag) async {
          if (widget.swipeNotifier.value == Swipe.right &&
              totalDragDistance > MediaQuery.of(context).size.width * 0.22) {
            // Update liked profile's likes and obtain the updated likes
            List<String> updatedLikes = await updateLikes();
            profile.likes = updatedLikes;
            await updateLikedProfiles(profile);

            // Check for a match using the updated likes
            if (checkForMatch(profile)) {
              // Display a notification for the match
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('It\'s a Link!'),
                    content: Text(
                      'You and ${profile.name} have liked each other!',
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
              // Add the matched profiles to a list
              widget.onMatched(widget.profile);
              debugPrint(emails.toString());
              debugPrint(updatedLikes.toString());
            }
          }
          widget.swipeNotifier.value = Swipe.none;
          totalDragDistance = 0;
        },

        childWhenDragging: Container(
          color: Colors.transparent,
        ),

        //This will be visible when we press action button
        child: ValueListenableBuilder(
            valueListenable: widget.swipeNotifier,
            builder: (BuildContext context, Swipe swipe, Widget? child) {
              return Stack(
                children: [
                  ProfileCard(profile: widget.profile),
                  // heck if this is the last card and Swipe is not equal to Swipe.none
                  swipe != Swipe.none && widget.isLastCard
                      ? swipe == Swipe.right
                          ? Positioned(
                              top: 40,
                              left: 20,
                              child: Transform.rotate(
                                angle: 12,
                                child: TagWidget(
                                  text: 'LIKE',
                                  color: Colors.green[400]!,
                                ),
                              ),
                            )
                          : Positioned(
                              top: 50,
                              right: 24,
                              child: Transform.rotate(
                                angle: -12,
                                child: TagWidget(
                                  text: 'DISLIKE',
                                  color: Colors.red[400]!,
                                ),
                              ),
                            )
                      : const SizedBox.shrink(),
                ],
              );
            }),
      ),
    );
  }
  Future<List<String>> updateLikes() async {
    final usersCollection = FirebaseFirestore.instance.collection('Users');
    final profileDoc = usersCollection.doc(widget.profile.email);

    try {
      List<String> temp = []; // Variable to store the updated likes

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(profileDoc);

        if (snapshot.exists) {
          final likes = List<String>.from(snapshot.data()?['likes'] ?? []);
          if (!likes.contains(currentUserEmail)) {
            likes.add(currentUserEmail);
            transaction.update(profileDoc, {'likes': likes});
             // Store the updated likes within the transaction
          }
          temp = likes;
        }
      });
      return temp; // Return the updated likes after the transaction
    } catch (error) {
      debugPrint('Error updating likes: $error');
    }
    return []; // Return an empty list if the update fails
  }


  //updating firebase of loggedin user by adding the profiles that logged in user has liked for filtering.
  Future<void> updateLikedProfiles(Profile profile) async {
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

  Future<void> processLikes() async {
    List<dynamic> likes = await getLikes();
    emails = List<String>.from(likes);
  }

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


  bool checkForMatch(Profile likedProfile) {
    bool isMatch = likedProfile.likes.contains(currentUserEmail) &&
        emails.contains(likedProfile.email);
    if (isMatch) {
    // Update the 'matches' field for the logged-in user
      FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserEmail)
          .update({
        'matches': FieldValue.arrayUnion([likedProfile.email])
      }).catchError((error) {
        debugPrint('Error updating matches: $error');
      });

      FirebaseFirestore.instance
          .collection('Users')
          .doc(likedProfile.email)
          .update({
        'matches': FieldValue.arrayUnion([currentUserEmail])
      }).catchError((error) {
        debugPrint('Error updating matches: $error');
      });
    }
    return isMatch;
        
  }



}

class TagWidget extends StatelessWidget {
  const TagWidget({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: color,
            width: 4,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 36,
        ),
      ),
    );
  }
}