import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twinkstar/screens/home/twink.dart';
import 'package:twinkstar/services/firestore_services.dart';
import 'package:twinkstar/services/auth_services.dart';

class UserTwinksScreen extends StatefulWidget {
  final String? userUid;
  final String twinksType;
  const UserTwinksScreen({super.key, this.userUid, required this.twinksType});

  @override
  State<UserTwinksScreen> createState() => _UserTwinksScreenState();
}

class _UserTwinksScreenState extends State<UserTwinksScreen> {
  CollectionReference refTwinks =
      FirebaseFirestore.instance.collection('Twinks');

  List<IconData> likedIcons = [];
  List<IconData> savedIcons = [];

  late Stream<QuerySnapshot> twinks;
  @override
  void initState() {
    super.initState();
    twinks = refTwinks.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: FutureBuilder<DocumentSnapshot>(
        future: FireStoreService().refUsers.doc(widget.userUid).get(),
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
            List<dynamic> twinkList = data[widget.twinksType];
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
                      if (!twinkList.contains(docSnapshot.id) &&
                          widget.twinksType == 'twinks') {
                        return const SizedBox.shrink();
                      }
                      if (widget.twinksType == 'likedTwinks' &&
                          !likedTwinks.contains(docSnapshot.id)) {
                        return const SizedBox.shrink();
                      }
                      if (widget.twinksType == 'savedTwinks' &&
                          !savedTwinks.contains(docSnapshot.id)) {
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
                          docSnapshot: docSnapshot);
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
