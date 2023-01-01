import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:twinkstar/services/auth_services.dart';
import 'package:twinkstar/services/firestore_services.dart';
import 'package:twinkstar/services/storage_services.dart';
import 'package:twinkstar/utils/profile_image.dart';
import 'package:twinkstar/utils/utils.dart';
import 'package:twinkstar/extensions/custom_theme_extension.dart';

class ProfileScreen extends StatefulWidget {
  final String? uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                        return Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(width: 50),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 45,
                              child: ProfilePicture(
                                  imgName: data['profileImage'], radius: 44),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 110,
                          child: Center(
                            child: ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    backgroundColor:
                                        context.theme.bottomSheetColor2,
                                    context: context,
                                    builder: ((context) {
                                      return Container(
                                        height: MediaQuery.of(context)
                                                .copyWith()
                                                .size
                                                .height *
                                            0.30,
                                        decoration: BoxDecoration(
                                          color:
                                              context.theme.bottomSheetColor2,
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(50),
                                            topLeft: Radius.circular(50),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CustomizedButton(
                                              buttonText:
                                                  'Change Profile Picture',
                                              onPressed: () async {
                                                var file =
                                                    await changePicture();

                                                StorageService().uploadFile(
                                                    file.path,
                                                    'profile_images');
                                              },
                                              buttonColor:
                                                  context.theme.liquidRefresh,
                                              textColor: Colors.white,
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            CustomizedButton(
                                              buttonText:
                                                  'Change Cover Picture',
                                              onPressed: () async {
                                                var file =
                                                    await changePicture();

                                                StorageService().uploadFile(
                                                    file.path, 'cover_images');
                                              },
                                              buttonColor:
                                                  context.theme.liquidRefresh,
                                              textColor: Colors.white,
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  );
                                },
                                child: const Icon(Icons.camera_alt_rounded)),
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
                    Chip(
                      label: Text('Twinks: ${twinks.length}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Chip(
                          label: Text('Following: ${following.length}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        Chip(
                          label: Text('Followers: ${followers.length}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
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
