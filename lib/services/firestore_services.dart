// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twinkstar/services/auth_services.dart';
import 'package:twinkstar/utils/utils.dart';

class FireStoreService {
  FirebaseFirestore ref = FirebaseFirestore.instance;
  CollectionReference refUsers = FirebaseFirestore.instance.collection('Users');
  CollectionReference refTwinks =
      FirebaseFirestore.instance.collection('Twinks');

  Future<bool> addUser(User? user, String name) async {
    bool userCreated = false;
    await refUsers.doc(user!.uid).set({
      'username': name,
      'email': user.email,
      'twinks': [],
      'following': [],
      'followers': [],
      'likedTwinks': [],
      'savedTwinks': [],
      'profileImage': 'user.png',
      'coverImage': 'user.png',
    }).then((value) {
      Toast.showToast('User Created', Colors.blue);
      userCreated = true;
    }).onError((error, stackTrace) {
      Toast.showToast(error.toString(), Colors.red);
    });
    return userCreated;
  }

  Future<bool> addUserBySocialLinkage(User? user) async {
    bool userCreated = false;
    await refUsers.doc(user!.uid).set({
      'username': user.displayName,
      'email': user.email,
      'twinks': [],
      'following': [],
      'followers': [],
      'likedTwinks': [],
      'savedTwinks': [],
      'profileImage': 'user.png',
      'coverImage': 'user.png',
    }).then((value) {
      Toast.showToast('User Created', Colors.blue);
      userCreated = true;
    }).onError((error, stackTrace) {
      Toast.showToast(error.toString(), Colors.red);
    });
    return userCreated;
  }

  Future<void> addTwink(String twink, String id, String username) async {
    await refTwinks.doc(id).set({
      'likes': 0,
      'saved': 0,
      'twink': twink,
      'user': FirebaseAuth.instance.currentUser!.uid,
      'email': FirebaseAuth.instance.currentUser!.email,
      'username': username,
      'time': DateTime.now(),
    });
    await refUsers.doc(FirebaseAuth.instance.currentUser!.uid).update({
      'twinks': FieldValue.arrayUnion([id]),
    });
  }

  Future<void> FollowUser(String currentUser, String followedUser) async {
    await refUsers.doc(currentUser).update({
      'following': FieldValue.arrayUnion([followedUser]),
    }).then((value) async {
      await refUsers.doc(followedUser).update({
        'followers': FieldValue.arrayUnion([currentUser]),
      });
    }).then((value) {
      Toast.showToast('Done', Colors.blue);
    });
  }

  Future<void> UnFollowUser(String currentUser, String followedUser) async {
    await refUsers.doc(currentUser).update({
      'following': FieldValue.arrayRemove([followedUser]),
    }).then((value) async {
      await refUsers.doc(followedUser).update({
        'followers': FieldValue.arrayRemove([currentUser]),
      });
    });
  }

  Future<void> likeTwink(String currentUser, String twinkID) async {
    await refUsers.doc(currentUser).update({
      'likedTwinks': FieldValue.arrayUnion([twinkID]),
    }).then((value) async {
      await refTwinks.doc(twinkID).update({
        'likes': FieldValue.increment(1),
      });
    });
  }

  Future<void> unLikeTwink(String currentUser, String twinkID) async {
    await refUsers.doc(currentUser).update({
      'likedTwinks': FieldValue.arrayRemove([twinkID]),
    }).then((value) async {
      await refTwinks.doc(twinkID).update({
        'likes': FieldValue.increment(-1),
      });
    });
  }

  Future<void> saveTwink(String currentUser, String twinkID) async {
    await refUsers.doc(currentUser).update({
      'savedTwinks': FieldValue.arrayUnion([twinkID]),
    }).then((value) async {
      await refTwinks.doc(twinkID).update({
        'saved': FieldValue.increment(1),
      });
    });
  }

  Future<void> unSaveTwink(String currentUser, String twinkID) async {
    await refUsers.doc(currentUser).update({
      'savedTwinks': FieldValue.arrayRemove([twinkID]),
    }).then((value) async {
      await refTwinks.doc(twinkID).update({
        'saved': FieldValue.increment(-1),
      });
    });
  }

  Future<void> uploadImage(String imgTitle, String imgName) async {
    await refUsers.doc(AuthService().firebaseAuth.currentUser!.uid).update({
      imgTitle: imgName,
    });
  }
}
