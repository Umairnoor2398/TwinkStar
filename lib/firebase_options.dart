// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAyDZk6L1vY3naJwzzJEOTfbU__psBikH0',
    appId: '1:653987777396:web:90178e089cd8086ef1ba21',
    messagingSenderId: '653987777396',
    projectId: 'twinkstar-9efcb',
    authDomain: 'twinkstar-9efcb.firebaseapp.com',
    storageBucket: 'twinkstar-9efcb.appspot.com',
    measurementId: 'G-BMWZ0ZW8EB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBlNb7moNLW3SBhjWHqQ8bQZPevG4qpxCI',
    appId: '1:653987777396:android:b9f7a69d524c7627f1ba21',
    messagingSenderId: '653987777396',
    projectId: 'twinkstar-9efcb',
    storageBucket: 'twinkstar-9efcb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDjSXad0-sg28BRviI8p3gYjO7a-2_lV6k',
    appId: '1:653987777396:ios:f1b282c8b94d445af1ba21',
    messagingSenderId: '653987777396',
    projectId: 'twinkstar-9efcb',
    storageBucket: 'twinkstar-9efcb.appspot.com',
    iosClientId: '653987777396-6t143851cf35s4gd2mi3k9p6n03ggj6s.apps.googleusercontent.com',
    iosBundleId: 'com.example.twinkstar',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDjSXad0-sg28BRviI8p3gYjO7a-2_lV6k',
    appId: '1:653987777396:ios:f1b282c8b94d445af1ba21',
    messagingSenderId: '653987777396',
    projectId: 'twinkstar-9efcb',
    storageBucket: 'twinkstar-9efcb.appspot.com',
    iosClientId: '653987777396-6t143851cf35s4gd2mi3k9p6n03ggj6s.apps.googleusercontent.com',
    iosBundleId: 'com.example.twinkstar',
  );
}
