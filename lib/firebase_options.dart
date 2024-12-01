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
    apiKey: 'AIzaSyDeps5p1DWEsgQKCu2auLfoqg16weHgNoo',
    appId: '1:185023998163:web:6b40f387c6f1a54eeb4c26',
    messagingSenderId: '185023998163',
    projectId: 'finalproject-c847e',
    authDomain: 'finalproject-c847e.firebaseapp.com',
    storageBucket: 'finalproject-c847e.appspot.com',
    measurementId: 'G-ZGG627TTGB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB8DGoXE9S-qVNHRj8AzVqCoChSPkCwRZo',
    appId: '1:185023998163:android:9ae1791a0cfe7128eb4c26',
    messagingSenderId: '185023998163',
    projectId: 'finalproject-c847e',
    storageBucket: 'finalproject-c847e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBSCG3M7fLTMyxdxejDrNo_iNXjY5sZM78',
    appId: '1:185023998163:ios:cb2abd87719d0cedeb4c26',
    messagingSenderId: '185023998163',
    projectId: 'finalproject-c847e',
    storageBucket: 'finalproject-c847e.appspot.com',
    iosBundleId: 'com.example.flutterFinalProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBSCG3M7fLTMyxdxejDrNo_iNXjY5sZM78',
    appId: '1:185023998163:ios:1ea8855b19afcf4eeb4c26',
    messagingSenderId: '185023998163',
    projectId: 'finalproject-c847e',
    storageBucket: 'finalproject-c847e.appspot.com',
    iosBundleId: 'com.example.flutterFinalProject.RunnerTests',
  );
}
