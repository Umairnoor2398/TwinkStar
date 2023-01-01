import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:twinkstar/screens/home/twink.dart';
import 'package:twinkstar/services/auth_services.dart';
import 'package:twinkstar/services/firestore_services.dart';
import 'package:twinkstar/extensions/custom_theme_extension.dart';

class TwinksScreen extends StatefulWidget {
  const TwinksScreen({super.key});

  @override
  State<TwinksScreen> createState() => _TwinksScreenState();
}

class _TwinksScreenState extends State<TwinksScreen> {
  CollectionReference refTwinks =
      FirebaseFirestore.instance.collection('Twinks');

  late Stream<QuerySnapshot> twinks;
  List<IconData> likedIcons = [];
  List<IconData> savedIcons = [];

  @override
  void initState() {
    super.initState();
    twinks = refTwinks.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      color: context.theme.liquidRefresh,
      backgroundColor: Colors.white,
      borderWidth: 2,
      springAnimationDurationInMilliseconds: 1000,
      showChildOpacityTransition: false,
      animSpeedFactor: 2,
      height: 200,
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        twinks = refTwinks.snapshots();
      },
      child: FutureBuilder<DocumentSnapshot>(
        future: FireStoreService()
            .refUsers
            .doc(AuthService().firebaseAuth.currentUser!.uid)
            .get(),
        builder:
            ((BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            List<dynamic> likedTwinks = data['likedTwinks'];
            List<dynamic> savedTwinks = data['savedTwinks'];
            List<dynamic> following = data['following'];
            return StreamBuilder<QuerySnapshot>(
              stream: twinks,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (snapshot.connectionState == ConnectionState.active) {
                  QuerySnapshot querySnapshot = snapshot.data;
                  List<QueryDocumentSnapshot> twinksList = querySnapshot.docs;
                  return ListView.builder(
                    itemCount: twinksList.length,
                    itemBuilder: ((context, index) {
                      final DocumentSnapshot docSnapshot = twinksList[index];
                      if (likedTwinks.contains(docSnapshot.id)) {
                        likedIcons.add(Icons.favorite_sharp);
                      } else {
                        likedIcons.add(Icons.favorite_border);
                      }
                      if (savedTwinks.contains(docSnapshot.id)) {
                        savedIcons.add(Icons.bookmark);
                      } else {
                        savedIcons.add(Icons.bookmark_border);
                      }
                      if (!following.contains(docSnapshot['user']) &&
                          docSnapshot['email'] !=
                              AuthService().firebaseAuth.currentUser!.email) {
                        return const SizedBox.shrink();
                      }

                      return Twink(
                        likedIcon: Icon(likedIcons[index]),
                        savedIcon: Icon(savedIcons[index]),
                        likePress: () {
                          if (likedTwinks.contains(docSnapshot.id)) {
                            FireStoreService().unLikeTwink(
                                AuthService().firebaseAuth.currentUser!.uid,
                                docSnapshot.id);
                            likedIcons[index] = Icons.favorite_border;
                          } else {
                            FireStoreService().likeTwink(
                                AuthService().firebaseAuth.currentUser!.uid,
                                docSnapshot.id);
                            likedIcons[index] = Icons.favorite_sharp;
                          }
                        },
                        savePress: () {
                          if (savedTwinks.contains(docSnapshot.id)) {
                            FireStoreService().unSaveTwink(
                                AuthService().firebaseAuth.currentUser!.uid,
                                docSnapshot.id);
                            savedIcons[index] = Icons.bookmark_border;
                          } else {
                            FireStoreService().saveTwink(
                                AuthService().firebaseAuth.currentUser!.uid,
                                docSnapshot.id);
                            savedIcons[index] = Icons.bookmark;
                          }
                        },
                        docSnapshot: docSnapshot,
                      );
                    }),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
