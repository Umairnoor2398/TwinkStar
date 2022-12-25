// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:twinkstar/data_classes/userDL.dart';
import 'package:twinkstar/screens/home/home_screen.dart';
import 'package:twinkstar/screens/welcome/forget_password_screen.dart';
import 'package:twinkstar/screens/welcome/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twinkstar/services/auth_services.dart';
import 'package:twinkstar/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool googleLoading = false;
  bool twitterLoading = false;
  bool githubLoading = false;
  bool loading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                    'Welcome Back! Glad\nto see you, Again!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CustomizedTextField(
                    controller: emailController,
                    hintText: 'Enter Your Email',
                    isPassword: false,
                    keyboardType: TextInputType.emailAddress),
                CustomizedTextField(
                    controller: passwordController,
                    hintText: 'Enter Your Password',
                    isPassword: true,
                    keyboardType: TextInputType.visiblePassword),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPassword()));
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Color(0xff6a707c)),
                        )),
                  ),
                ),
                loading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomizedLoginSignupButton(
                        buttonText: 'LOG IN',
                        buttonColor: Colors.black,
                        textColor: Colors.white,
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          User? user = await AuthService().login(
                              emailController.text.trim(),
                              passwordController.text.trim());
                          if (user != null) {
                            UserInfoDL.GetUserInfo(
                                AuthService().firebaseAuth.currentUser!.email);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeUIScreen()),
                                (route) => false);
                          }
                          setState(() {
                            loading = true;
                          });
                        }),

                // SizedBox(height: 20),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SingleChildScrollView(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Expanded(
                                child: Divider(
                                    thickness: 1,
                                    color: Colors.grey,
                                    height: 1),
                              ),
                              Text("  Or Login With  ",
                                  style: TextStyle(fontSize: 18)),
                              Expanded(
                                child: Divider(
                                    thickness: 1,
                                    color: Colors.grey,
                                    height: 1),
                              ),
                            ],
                          ),
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
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomeUIScreen()),
                                          (route) => false);
                                    }
                                    setState(() {
                                      googleLoading = false;
                                    });
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
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomeUIScreen()),
                                          (route) => false);
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
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomeUIScreen()),
                                          (route) => false);
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
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Don't have an Account?",
                        style:
                            TextStyle(fontSize: 15, color: Color(0xff1e232c)),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                          },
                          child: const Text(
                            'Create One',
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
}
