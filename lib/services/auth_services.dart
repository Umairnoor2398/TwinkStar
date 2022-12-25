// ignore_for_file: unused_local_variable, avoid_print, non_constant_identifier_names, invalid_use_of_visible_for_testing_member

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:twinkstar/utils/utils.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<User?> register(String email, String pass) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: pass);
      return userCredential.user;
    } catch (e) {
      Toast.showToast(e.toString(), Colors.red);
    }
    return null;
  }

  Future<User?> login(String email, String pass) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: pass);
      return userCredential.user;
    } catch (e) {
      Toast.showToast(e.toString(), Colors.red);
    }
    return null;
  }

  Future<User?> signInWithGoogle() async {
    //trigger the Authentication Dialog
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        //Obtain Auth Detail from request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new Credential
        final Credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // Once Signed In return the user data from firebase
        UserCredential userCredential =
            await firebaseAuth.signInWithCredential(Credential);

        return userCredential.user;
      }
    } catch (e) {
      Toast.showToast(e.toString(), Colors.red);
    }
    return null;
  }

  // Future<User?> signInWithFacebook() async {
  //   // Trigger the sign-in flow
  //   final LoginResult loginResult = await FacebookAuth.instance.login();

  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential =
  //       FacebookAuthProvider.credential(loginResult.accessToken!.token);

  //   // Once signed in, return the UserCredential
  //   UserCredential user = await FirebaseAuth.instance
  //       .signInWithCredential(facebookAuthCredential);
  //   return user.user;
  // }

  Future<User?> signInWithMicrosoft() async {
    final microsoftProvider = MicrosoftAuthProvider();
    UserCredential user;
    if (kIsWeb) {
      user = await FirebaseAuth.instance.signInWithPopup(microsoftProvider);
    } else {
      user = await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
    }
    return user.user;
  }

  Future<User?> signInWithGitHub() async {
    // Create a new provider
    GithubAuthProvider githubProvider = GithubAuthProvider();

    UserCredential user =
        await FirebaseAuth.instance.signInWithProvider(githubProvider);
    return user.user;
  }

  Future<User?> signInWithTwitter() async {
    TwitterAuthProvider twitterProvider = TwitterAuthProvider();
    UserCredential user;
    if (kIsWeb) {
      user = await FirebaseAuth.instance.signInWithPopup(twitterProvider);
    } else {
      user = await FirebaseAuth.instance.signInWithProvider(twitterProvider);
    }
    return user.user;
  }

  Future signout() async {
    GithubAuthProvider githubProvider = GithubAuthProvider();

    // await FacebookAuth.getInstance().logOut();
    await GoogleSignIn().signOut();
    await firebaseAuth.signOut();
  }
}
