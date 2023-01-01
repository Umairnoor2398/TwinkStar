import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // Once Signed In return the user data from firebase
        UserCredential userCredential =
            await firebaseAuth.signInWithCredential(credential);

        return userCredential.user;
      }
    } catch (e) {
      Toast.showToast(e.toString(), Colors.red);
    }
    return null;
  }

  Future<User?> signInWithGitHub() async {
    // Create a new provider
    GithubAuthProvider githubProvider = GithubAuthProvider();

    UserCredential user =
        await FirebaseAuth.instance.signInWithProvider(githubProvider);
    return user.user;
  }

  Future signout() async {
    await GoogleSignIn().signOut();
    await firebaseAuth.signOut();
  }
}
