import 'package:flutter/material.dart';
import 'package:twinkstar/screens/home/user_twink_screen.dart';

class User_ProfileScreen extends StatefulWidget {
  final String? uid;
  const User_ProfileScreen({super.key, this.uid});

  @override
  State<User_ProfileScreen> createState() => _User_ProfileScreenState();
}

class _User_ProfileScreenState extends State<User_ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: UserTwinksScreen(twinksType: 'twinks', userUid: widget.uid),
    );
  }
}
