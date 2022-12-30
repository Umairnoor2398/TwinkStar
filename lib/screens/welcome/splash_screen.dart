// ignore_for_file: depend_on_referenced_packages

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:twinkstar/data_classes/userDL.dart';
import 'package:twinkstar/screens/home/home_screen.dart';
import 'package:twinkstar/screens/welcome/onboarding_screen.dart';
import 'package:twinkstar/services/auth_services.dart';
import 'package:twinkstar/extensions/custom_theme_extension.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    if (AuthService().firebaseAuth.currentUser != null) {
      UserInfoDL.GetUserInfo(AuthService().firebaseAuth.currentUser!.email);
    }

    return AnimatedSplashScreen(
      splash: Lottie.asset('assets/jsons/loading.json'),
      backgroundColor: context.theme.backgroundColor!,
      nextScreen: AuthService().firebaseAuth.currentUser != null
          ? const HomeUIScreen()
          : const OnboardingPageState(),
      splashIconSize: 500,
      duration: 6000,
      // splashTransition: SplashTransition.fadeTransition,
      // pageTransitionType: PageTransitionType.size,
    );
  }
}
