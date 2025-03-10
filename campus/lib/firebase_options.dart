// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBwdIld5LXdNU1w-0_LUIzdgUjua0hiPyM',
    appId: '1:729165556765:web:2bbde85e9484327cbeaaf4',
    messagingSenderId: '729165556765',
    projectId: 'campus-a3209',
    authDomain: 'campus-a3209.firebaseapp.com',
    storageBucket: 'campus-a3209.firebasestorage.app',
    measurementId: 'G-ZD8ZJL15KT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBckWZHLNW1APWgEp5fVUecjX8E4TQYi-8',
    appId: '1:729165556765:android:92df72e2c860a94ebeaaf4',
    messagingSenderId: '729165556765',
    projectId: 'campus-a3209',
    storageBucket: 'campus-a3209.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC9Q-mLfxh9FXnS82ty7QoBP5_zR5f6c4U',
    appId: '1:729165556765:ios:ff257276a3474022beaaf4',
    messagingSenderId: '729165556765',
    projectId: 'campus-a3209',
    storageBucket: 'campus-a3209.firebasestorage.app',
    iosBundleId: 'com.example.campus',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC9Q-mLfxh9FXnS82ty7QoBP5_zR5f6c4U',
    appId: '1:729165556765:ios:ff257276a3474022beaaf4',
    messagingSenderId: '729165556765',
    projectId: 'campus-a3209',
    storageBucket: 'campus-a3209.firebasestorage.app',
    iosBundleId: 'com.example.campus',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBwdIld5LXdNU1w-0_LUIzdgUjua0hiPyM',
    appId: '1:729165556765:web:cc4d31a85dab9eb6beaaf4',
    messagingSenderId: '729165556765',
    projectId: 'campus-a3209',
    authDomain: 'campus-a3209.firebaseapp.com',
    storageBucket: 'campus-a3209.firebasestorage.app',
    measurementId: 'G-VN9PQ8EQ9X',
  );
}
