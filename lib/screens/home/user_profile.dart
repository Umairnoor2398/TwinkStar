import 'package:flutter/material.dart';
import 'package:twinkstar/screens/home/user_twink_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final String? uid;
  const UserProfileScreen({super.key, this.uid});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: UserTwinksScreen(twinksType: 'twinks', userUid: widget.uid),
    );
  }
}
