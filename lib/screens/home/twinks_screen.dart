import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:twinkstar/services/auth_services.dart';
import 'package:twinkstar/services/firestore_services.dart';
import 'package:twinkstar/services/storage_services.dart';

class TwinksScreen extends StatefulWidget {
  const TwinksScreen({super.key});

  @override
  State<TwinksScreen> createState() => _TwinksScreenState();
}

class _TwinksScreenState extends State<TwinksScreen> {
  CollectionReference refTwinks =
      FirebaseFirestore.instance.collection('Twinks');

  late Stream<QuerySnapshot> twinks;
  late var user;
  List<IconData> likedIcons = [];
  List<IconData> savedIcons = [];

  @override
  void initState() {
    super.initState();
    twinks = refTwinks.snapshots();
    user = FireStoreService()
        .refUsers
        .doc(AuthService().firebaseAuth.currentUser!.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    // return Container();
    return LiquidPullToRefresh(
      color: Colors.blue,
      backgroundColor: Colors.white,
      borderWidth: 2,
      springAnimationDurationInMilliseconds: 1000,
      showChildOpacityTransition: false,
      animSpeedFactor: 2,
      height: 200,
      onRefresh: () async {
        // twinks = null;
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

                      return Column(
                        children: [
                          const Divider(height: 5.0),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.black,
                              child: FutureBuilder(
                                future: StorageService().downloadUrl(
                                    'profile_images', '${docSnapshot['user']}'),
                                builder: ((BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.hasData) {
                                    return CircleAvatar(
                                      backgroundColor: Colors.white,
                                      backgroundImage:
                                          NetworkImage(snapshot.data!),
                                    );
                                  }
                                  if (snapshot.connectionState ==
                                          ConnectionState.waiting ||
                                      snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }
                                  return const CircularProgressIndicator();
                                }),
                              ),
                            ),
                            title: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          docSnapshot['username'].toString(),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '@${docSnapshot['email'].toString()}',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      timeago
                                          .format(docSnapshot['time'].toDate()),
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontStyle: FontStyle.normal,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  docSnapshot['twink'].toString().trim(),
                                  overflow: TextOverflow.clip,
                                  maxLines: null,
                                ),
                                //Adding Image if possible
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              // update(docSnapshot, 'likes',1);
                                              if (likedTwinks
                                                  .contains(docSnapshot.id)) {
                                                FireStoreService().unLikeTwink(
                                                    AuthService()
                                                        .firebaseAuth
                                                        .currentUser!
                                                        .uid,
                                                    docSnapshot.id);
                                                likedIcons[index] =
                                                    Icons.favorite_border;
                                              } else {
                                                FireStoreService().likeTwink(
                                                    AuthService()
                                                        .firebaseAuth
                                                        .currentUser!
                                                        .uid,
                                                    docSnapshot.id);
                                                likedIcons[index] =
                                                    Icons.favorite_sharp;
                                              }
                                            },
                                            icon: Icon(likedIcons[index])),
                                        Text(
                                          docSnapshot['likes']
                                              .toString()
                                              .trim(),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              if (savedTwinks
                                                  .contains(docSnapshot.id)) {
                                                FireStoreService().unSaveTwink(
                                                    AuthService()
                                                        .firebaseAuth
                                                        .currentUser!
                                                        .uid,
                                                    docSnapshot.id);
                                                savedIcons[index] =
                                                    Icons.bookmark_border;
                                              } else {
                                                FireStoreService().saveTwink(
                                                    AuthService()
                                                        .firebaseAuth
                                                        .currentUser!
                                                        .uid,
                                                    docSnapshot.id);
                                                savedIcons[index] =
                                                    Icons.bookmark;
                                              }
                                            },
                                            icon: Icon(savedIcons[index])),
                                        Text(
                                          docSnapshot['saved']
                                              .toString()
                                              .trim(),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
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

  ListView twinkListView(List<QueryDocumentSnapshot<Object?>> twinksList) {
    return ListView.builder(
      itemCount: twinksList.length,
      itemBuilder: ((context, index) {
        final DocumentSnapshot docSnapshot = twinksList[index];
        return Column(
          children: [
            const Divider(height: 5.0),
            twinkListTile(docSnapshot),
          ],
        );
      }),
    );
  }

  ListTile twinkListTile(DocumentSnapshot<Object?> docSnapshot) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(docSnapshot['user']),
      ),
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    docSnapshot['username'].toString(),
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '@${docSnapshot['email'].toString()}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.normal,
                        color: Colors.grey),
                  ),
                ],
              ),
              Text(
                timeago.format(docSnapshot['time'].toDate()),
                style: const TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.normal,
                    color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            docSnapshot['twink'].toString().trim(),
            overflow: TextOverflow.clip,
            maxLines: null,
          ),
          //Adding Image if possible
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        // update(docSnapshot, 'likes',1);
                      },
                      icon: const Icon(Icons.favorite_border)),
                  Text(
                    docSnapshot['likes'].toString().trim(),
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        // update(docSnapshot, 'saved',1);
                      },
                      icon: const Icon(Icons.bookmark_border)),
                  Text(
                    docSnapshot['saved'].toString().trim(),
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
