import 'dart:async';
import 'package:flutter/material.dart';
import 'package:twinkstar/screens/welcome/welcome_screen.dart';
import 'package:twinkstar/services/auth_services.dart';
import 'package:twinkstar/utils/utils.dart';

class Logout extends StatefulWidget {
  const Logout({Key? key}) : super(key: key);

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(milliseconds: 500), () {
      AuthService().signout();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()));
      Toast.showToast("Logged out", Colors.blue[300]!);
    });
    return Container();
  }
}
