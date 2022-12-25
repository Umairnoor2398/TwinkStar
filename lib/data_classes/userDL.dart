// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:twinkstar/services/auth_services.dart';
import 'package:twinkstar/services/firestore_services.dart';

import 'user.dart';

class UserInfoDL {
  // static late UserInfo currUser;
  // static late List<UserInfo> usersList;

  static void GetUserInfo(String? uid) async {
    // var snapshots = await FireStoreService().refUsers.get();
    // for (var element in snapshots.docs) {
    //   Map<String, dynamic> obj = element.data as Map<String, dynamic>;
    //   UserInfo u = UserInfo(
    //       obj['username'],
    //       obj['email'],
    //       obj['twinks'],
    //       obj['likedTwinks'],
    //       obj['savedTwinks'],
    //       obj['followers'],
    //       obj['following']);
    //   usersList.add(u);
    //   if (u.email == AuthService().firebaseAuth.currentUser!.email) {
    //     currUser = UserInfo.copy(u);
    //   }
    // }
  }
}
