import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twinkstar/services/auth_services.dart';
import 'package:twinkstar/services/firestore_services.dart';
import 'package:twinkstar/utils/utils.dart';

class CreateTwinkScreen extends StatefulWidget {
  const CreateTwinkScreen({super.key});

  @override
  State<CreateTwinkScreen> createState() => _CreateTwinkScreenState();
}

class _CreateTwinkScreenState extends State<CreateTwinkScreen> {
  final TextEditingController twinkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FutureBuilder<DocumentSnapshot>(
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
              return Column(
                children: [
                  CustomTextField(
                      isPassword: false,
                      controller: twinkController,
                      hintText: 'Create Post',
                      inputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline),
                  CustomizedButton(
                      buttonText: 'Twink',
                      buttonColor: Colors.black,
                      textColor: Colors.white,
                      onPressed: () async {
                        if (data['profileImage'] == 'user.png') {
                          Toast.showToast(
                              'You must upload a profile picture first in order to post a twink',
                              Colors.red);
                        } else {
                          int idx = twinks.length;
                          String uid =
                              '${FirebaseAuth.instance.currentUser!.email}-${idx + 1}';

                          FireStoreService().addTwink(
                              twinkController.text.trim(),
                              uid,
                              data['username']);
                          setState(() {
                            twinkController.text = '';
                          });
                        }
                      }),
                ],
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}
