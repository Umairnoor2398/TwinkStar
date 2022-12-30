// ignore_for_file: dead_code

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:twinkstar/utils/utils.dart';
import 'package:twinkstar/screens/welcome/login_screen.dart';
import 'package:twinkstar/screens/welcome/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () {
        // loginBottomSheet(context);
      },
    );
    // return const OnboardingPageState();
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/logo.png'),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // SizedBox(height: 100,child: Image.asset('assets/images/logo_dark.png')),
            CustomizedButton(
                buttonText: 'LOG IN',
                buttonColor: Colors.black,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }),
            const SizedBox(height: 10),
            CustomizedButton(
                buttonText: 'SIGN UP',
                buttonColor: Colors.white,
                textColor: Colors.black,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()));
                }),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
