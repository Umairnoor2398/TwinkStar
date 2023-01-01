import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:twinkstar/screens/home/logout_screen.dart';
import 'package:twinkstar/screens/home/post_twink_screen.dart';
import 'package:twinkstar/screens/home/profile_screen.dart';
import 'package:twinkstar/screens/home/search_screen.dart';
import 'package:twinkstar/screens/home/twinks_screen.dart';
import 'package:twinkstar/screens/home/user_twink_screen.dart';
import 'package:twinkstar/services/auth_services.dart';

class MainScreen extends StatefulWidget {
  final int idx;
  static final CollectionReference users =
      FirebaseFirestore.instance.collection('Users');

  const MainScreen({Key? key, required this.idx}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final pages = <Widget>[
    const TwinksScreen(),
    const SearchScreen(),
    ProfileScreen(uid: AuthService().firebaseAuth.currentUser!.uid),
    UserTwinksScreen(
      userUid: AuthService().firebaseAuth.currentUser!.uid,
      twinksType: 'twinks',
    ),
    UserTwinksScreen(
      userUid: AuthService().firebaseAuth.currentUser!.uid,
      twinksType: 'likedTwinks',
    ),
    UserTwinksScreen(
      userUid: AuthService().firebaseAuth.currentUser!.uid,
      twinksType: 'savedTwinks',
    ),
    const CreateTwinkScreen(),
    const Logout(),
  ];

  final screen = [
    "Home",
    "Search",
    "Profile",
    "My Twinks",
    "Liked Twinks",
    "Saved Twinks",
    "Create Twink",
    ""
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          title: Text(screen[widget.idx]),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          leading: IconButton(
              onPressed: () => ZoomDrawer.of(context)!.toggle(),
              icon: const Icon(Icons.menu)),
        ),
      ),
      body: pages[widget.idx],
    );
  }
}
