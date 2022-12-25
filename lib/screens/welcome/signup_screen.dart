// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:twinkstar/data_classes/userDL.dart';
import 'package:twinkstar/screens/home/home_screen.dart';
import 'package:twinkstar/screens/welcome/login_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twinkstar/services/auth_services.dart';
import 'package:twinkstar/services/firestore_services.dart';
import 'package:twinkstar/utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool googleLoading = false;
  bool twitterLoading = false;
  bool githubLoading = false;
  bool loading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_sharp),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    )),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Hello Register to get Started',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CustomizedTextField(
                    controller: nameController,
                    hintText: 'UserName',
                    errorText: 'Username Cannot be Empty',
                    isPassword: false,
                    keyboardType: TextInputType.name),
                CustomizedTextField(
                    controller: emailController,
                    hintText: 'Email',
                    errorText: 'Email Cannot be Empty',
                    isPassword: false,
                    keyboardType: TextInputType.emailAddress),
                CustomizedTextField(
                    controller: passwordController,
                    hintText: 'Enter Your Password',
                    errorText: 'Password Cannot be Empty',
                    isPassword: true,
                    keyboardType: TextInputType.visiblePassword),
                CustomizedTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Your Password',
                    errorText: 'Password Cannot be Empty',
                    isPassword: true,
                    keyboardType: TextInputType.visiblePassword),
                loading
                    ? const CircularProgressIndicator()
                    : CustomizedLoginSignupButton(
                        buttonText: 'Register',
                        buttonColor: Colors.black,
                        textColor: Colors.white,
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          if (nameController.text.trim().length > 4) {
                            if (emailController.text.trim().isNotEmpty) {
                              if (passwordValidation(
                                  passwordController.text.trim(),
                                  confirmPasswordController.text.trim())) {
                                //

                                User? user = await AuthService().register(
                                    emailController.text.trim(),
                                    passwordController.text.trim());
                                if (user != null) {
                                  UserInfoDL.GetUserInfo(AuthService()
                                      .firebaseAuth
                                      .currentUser!
                                      .email);
                                  if (await FireStoreService().addUser(
                                      user, nameController.text.trim())) {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeUIScreen()),
                                        (route) => false);
                                  }
                                }
                              }
                            } else {
                              Toast.showToast(
                                  'Email cannot Be Empty', Colors.red);
                            }
                          } else {
                            Toast.showToast(
                                'UserName must be More than 4 Characters Long',
                                Colors.red);
                          }
                          setState(() {
                            loading = false;
                          });
                        }),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Expanded(
                              child: Divider(
                                  thickness: 1, color: Colors.grey, height: 1),
                            ),
                            Text("  Or Register With  ",
                                style: TextStyle(fontSize: 18)),
                            Expanded(
                              child: Divider(
                                  thickness: 1, color: Colors.grey, height: 1),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            googleLoading
                                ? const CircularProgressIndicator()
                                : SignInButton(Buttons.Google,
                                    text: 'Continue With Google',
                                    onPressed: () async {
                                    setState(() {
                                      googleLoading = true;
                                    });
                                    User? user =
                                        await AuthService().signInWithGoogle();
                                    if (user != null) {
                                      UserInfoDL.GetUserInfo(AuthService()
                                          .firebaseAuth
                                          .currentUser!
                                          .email);
                                      if (await FireStoreService()
                                          .addUserBySocialLinkage(user)) {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomeUIScreen()),
                                            (route) => false);
                                      }
                                    }
                                  }),
                            twitterLoading
                                ? const CircularProgressIndicator()
                                : SignInButton(Buttons.Twitter,
                                    text: 'Continue With Twitter',
                                    onPressed: () async {
                                    setState(() {
                                      twitterLoading = true;
                                    });
                                    User? user =
                                        await AuthService().signInWithTwitter();
                                    if (user != null) {
                                      UserInfoDL.GetUserInfo(AuthService()
                                          .firebaseAuth
                                          .currentUser!
                                          .email);
                                      if (await FireStoreService()
                                          .addUserBySocialLinkage(user)) {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomeUIScreen()),
                                            (route) => false);
                                      }
                                    }
                                    setState(() {
                                      twitterLoading = false;
                                    });
                                  }),
                            githubLoading
                                ? const CircularProgressIndicator()
                                : SignInButton(Buttons.GitHub,
                                    text: 'Continue With GitHub',
                                    onPressed: () async {
                                    setState(() {
                                      githubLoading = true;
                                    });
                                    User? user =
                                        await AuthService().signInWithGitHub();
                                    if (user != null) {
                                      UserInfoDL.GetUserInfo(AuthService()
                                          .firebaseAuth
                                          .currentUser!
                                          .email);
                                      if (await FireStoreService()
                                          .addUserBySocialLinkage(user)) {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomeUIScreen()),
                                            (route) => false);
                                      }
                                    }
                                    setState(() {
                                      githubLoading = false;
                                    });
                                  }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an Account?",
                        style:
                            TextStyle(fontSize: 15, color: Color(0xff1e232c)),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                                fontSize: 15, color: Color(0xff35c2c1)),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool passContentValidation(String p) {
    int digCount = 0;
    for (int i = 0; i < p.length; i++) {
      String s = p[i];
      if (s.contains('1') ||
          s.contains('2') ||
          s.contains('3') ||
          s.contains('4') ||
          s.contains('5') ||
          s.contains('6') ||
          s.contains('7') ||
          s.contains('8') ||
          s.contains('9') ||
          s.contains('0')) {
        digCount++;
      }
    }
    if (digCount >= 1) {
      return true;
    }
    Toast.showToast('Password Must Contain at least 1 digit', Colors.red);
    return false;
  }

  bool passwordValidation(String pass, String confirmPass) {
    if (pass == confirmPass) {
      if (pass.length >= 8) {
        return passContentValidation(pass);
      } else {
        Toast.showToast(
            'Password Must Be at least 8 Characters Long', Colors.red);
        return false;
      }
    } else {
      Toast.showToast('Password and Confirm Password Must be Same', Colors.red);
      return false;
    }
  }
}
