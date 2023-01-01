// ignore_for_file: avoid_function_literals_in_foreach_calls, non_constant_identifier_names

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:twinkstar/services/firestore_services.dart';
import 'package:twinkstar/utils/utils.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Reference get firebaseStorage => FirebaseStorage.instance.ref();

  Future<void> uploadFile(String path, String folderPath) async {
    File file = File(path);
    try {
      await storage
          .ref()
          .child('$folderPath/${FirebaseAuth.instance.currentUser!.uid}')
          .putFile(file);
      if (folderPath[0] == 'c') {
        FireStoreService()
            .uploadImage('coverImage', FirebaseAuth.instance.currentUser!.uid);
      } else {
        FireStoreService().uploadImage(
            'profileImage', FirebaseAuth.instance.currentUser!.uid);
      }
    } on firebase_core.FirebaseException catch (e) {
      Toast.showToast(e.toString(), Colors.red);
    }
  }

  Future<String> downloadUrl(String folderName, String ImageName) async {
    String downloadURL =
        await storage.ref('$folderName/$ImageName').getDownloadURL();

    return downloadURL;
  }
}
