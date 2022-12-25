import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:twinkstar/data_classes/userDL.dart';
import 'package:twinkstar/screens/home/home_screen.dart';
import 'package:twinkstar/screens/welcome/welcome_screen.dart';
import 'package:twinkstar/services/auth_services.dart';

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
      splash: Lottie.asset('assets/jsons/98432-loading.json'),
      backgroundColor: Colors.white,
      nextScreen: AuthService().firebaseAuth.currentUser != null
          ? const HomeUIScreen()
          : const WelcomeScreen(),
      splashIconSize: 500,
      // duration: 4000,
      // splashTransition: SplashTransition.fadeTransition,
      // pageTransitionType: PageTransitionType.fade,
    );
  }
}
