// ignore_for_file: unused_local_variable, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twinkstar/screens/home/user_profile.dart';
import 'package:twinkstar/services/auth_services.dart';
import 'package:twinkstar/services/firestore_services.dart';
import 'package:twinkstar/utils/profile_image.dart';
import 'package:twinkstar/utils/utils.dart';
import 'package:twinkstar/extensions/custom_theme_extension.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String followBtnText = 'Follow';
  List<String> followBtnTXT = [];
  // final Storage storage = new Storage();
  TextEditingController nameController = TextEditingController();
  late var currUser;
  late var users;

  @override
  void initState() {
    super.initState();
    currUser = FireStoreService()
        .refUsers
        .doc(AuthService().firebaseAuth.currentUser!.uid)
        .get();
    users = FireStoreService().refUsers.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FireStoreService()
          .refUsers
          .doc(AuthService().firebaseAuth.currentUser!.uid)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          List<dynamic> following = data['following'];
          return StreamBuilder(
            stream: users,
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return Column(
                  children: [
                    CustomizedTextField(
                      isPassword: false,
                      hintText: 'Enter Username',
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot docSnapshot =
                              streamSnapshot.data!.docs[index];
                          if (following.contains(docSnapshot.id)) {
                            followBtnTXT.add('Following');
                          } else {
                            followBtnTXT.add('Follow');
                          }
                          if (docSnapshot.id ==
                              AuthService().firebaseAuth.currentUser!.uid) {
                            return const SizedBox.shrink();
                          }
                          if (docSnapshot['username']
                              .toString()
                              .toLowerCase()
                              .contains(nameController.text.toLowerCase())) {
                            return Card(
                              margin: const EdgeInsets.all(10),
                              child: ListTile(
                                onTap: () {
                                  Map<String, dynamic> data = docSnapshot.data()
                                      as Map<String, dynamic>;
                                  List<dynamic> twinks = data['twinks'];
                                  List<dynamic> following = data['following'];
                                  List<dynamic> followers = data['followers'];
                                  userMiniProfileBottomSheet(
                                      context,
                                      docSnapshot,
                                      followers,
                                      twinks,
                                      following);
                                },
                                leading: ProfilePicture(
                                    imgName: docSnapshot['profileImage'],
                                    radius: 25),
                                title: Text(docSnapshot['username']),
                                subtitle: Text(
                                  docSnapshot['email'],
                                  style: const TextStyle(fontSize: 12),
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () async {
                                    if (followBtnTXT[index] == 'Follow') {
                                      await FireStoreService().FollowUser(
                                          AuthService()
                                              .firebaseAuth
                                              .currentUser!
                                              .uid,
                                          docSnapshot.id);
                                      followBtnTXT[index] = 'Following';
                                    } else if (followBtnTXT[index] ==
                                        'Following') {
                                      await FireStoreService().UnFollowUser(
                                          AuthService()
                                              .firebaseAuth
                                              .currentUser!
                                              .uid,
                                          docSnapshot.id);
                                      followBtnTXT[index] = 'Follow';
                                    }
                                    setState(() {});
                                  },
                                  child: Text(followBtnTXT[index]),
                                ),
                              ),
                            );
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<dynamic> userMiniProfileBottomSheet(
      BuildContext context,
      DocumentSnapshot<Object?> docSnapshot,
      List<dynamic> followers,
      List<dynamic> twinks,
      List<dynamic> following) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: ((context) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Main Body
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.1,
                    decoration: BoxDecoration(
                      color: context.theme.bottomSheetColor!,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                    ),
                  ),
                ),
                //Circular Avarat
                Positioned(
                  top: 14,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    child: ProfilePicture(
                        imgName: docSnapshot['profileImage'], radius: 65),
                  ),
                ),
                // Display Username
                Positioned(
                  top: MediaQuery.of(context).size.height / 5,
                  child: Text(
                    docSnapshot['username'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                // Display Email
                Positioned(
                  top: MediaQuery.of(context).size.height / 4.3,
                  child: Text(
                    docSnapshot['email'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                // Display Twinks, Followers, Following
                Positioned(
                  top: MediaQuery.of(context).size.height / 3,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.1,
                    height: MediaQuery.of(context).size.height / 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BottomSheetItem(
                            title: 'Followers',
                            subtitle: followers.length.toString()),
                        BottomSheetItem(
                            title: 'Twinks',
                            subtitle: twinks.length.toString()),
                        BottomSheetItem(
                            title: 'Following',
                            subtitle: following.length.toString()),
                      ],
                    ),
                  ),
                ),
                // Button
                Positioned(
                  bottom: 30,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => User_ProfileScreen(
                                    uid: docSnapshot.id,
                                  )));
                    },
                    minWidth: MediaQuery.of(context).size.width / 1.1,
                    height: MediaQuery.of(context).size.height / 16,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    splashColor: Colors.blue,
                    child: Center(
                      child: Text(
                        "See ${docSnapshot['username']}'s Twinks ",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }));
  }
}

class BottomSheetItem extends StatelessWidget {
  final String title;
  final String subtitle;
  const BottomSheetItem({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 5,
      height: MediaQuery.of(context).size.height / 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
