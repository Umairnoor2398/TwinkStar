// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:twinkstar/services/auth_services.dart';
import 'package:twinkstar/services/firestore_services.dart';
import 'package:twinkstar/services/storage_services.dart';
import 'package:twinkstar/utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  final String? uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String cImage =
      'https://th.bing.com/th/id/OIP.ocS9ZrZ36t4esy0IV2Rc3AHaCv?pid=ImgDet&rs=1';

  @override
  void initState() {
    super.initState();
  }

  Future<File> changePicture() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['png'],
    );

    return File(result!.files.first.path!);
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
          List<dynamic> twinks = data['twinks'];
          List<dynamic> followers = data['followers'];
          List<dynamic> following = data['following'];
          return ListView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    color: Colors.blue,
                  ),
                  child: FutureBuilder(
                    future: StorageService()
                        .downloadUrl('cover_images', '${data['coverImage']}'),
                    builder: ((BuildContext context,
                        AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return SizedBox(
                          child: Image.network(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      return const CircularProgressIndicator();
                    }),
                  ),
                ),
              ),
              Container(
                transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 45,
                            child: FutureBuilder(
                              future: StorageService().downloadUrl(
                                  'profile_images', '${data['profileImage']}'),
                              builder: ((BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  return CircleAvatar(
                                    radius: 43,
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
                        ),
                        SizedBox(
                          height: 110,
                          child: Center(
                            child: ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: ((context) {
                                      return Container(
                                        height: MediaQuery.of(context)
                                                .copyWith()
                                                .size
                                                .height *
                                            0.30,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(50),
                                            topLeft: Radius.circular(50),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CustomizedLoginSignupButton(
                                              buttonText:
                                                  'Change Profile Picture',
                                              onPressed: () async {
                                                var file =
                                                    await changePicture();

                                                StorageService().uploadFile(
                                                    file.path,
                                                    'profile_images');
                                              },
                                              buttonColor: Colors.blue,
                                              textColor: Colors.white,
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            CustomizedLoginSignupButton(
                                              buttonText:
                                                  'Change Cover Picture',
                                              onPressed: () async {
                                                var file =
                                                    await changePicture();

                                                StorageService().uploadFile(
                                                    file.path, 'cover_images');
                                              },
                                              buttonColor: Colors.blue,
                                              textColor: Colors.white,
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  );
                                },
                                child: const Text('Edit Picture')),
                          ),
                        ),
                      ],
                    ),
                    Text(data['username'],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(
                      data['email'],
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text('Twinks: ${twinks.length}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('Following: ${following.length}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('Followers: ${followers.length}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
