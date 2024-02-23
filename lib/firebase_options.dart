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
    apiKey: 'AIzaSyC-gip66NdBePSjqyhiHI4LathxZ6QIrmk',
    appId: '1:877229430819:web:f186233cc5a1dc1452f996',
    messagingSenderId: '877229430819',
    projectId: 'chit-chat-21bd4',
    authDomain: 'chit-chat-21bd4.firebaseapp.com',
    storageBucket: 'chit-chat-21bd4.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCPPNLTR0YhF7MDHSOlR8dMqpNCneaKpVY',
    appId: '1:877229430819:android:0c64ad1ef389750b52f996',
    messagingSenderId: '877229430819',
    projectId: 'chit-chat-21bd4',
    storageBucket: 'chit-chat-21bd4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBDtDSBZhN7598paEZwzHqCf950fkHAxU0',
    appId: '1:877229430819:ios:1badbd3dc6e5b92652f996',
    messagingSenderId: '877229430819',
    projectId: 'chit-chat-21bd4',
    storageBucket: 'chit-chat-21bd4.appspot.com',
    androidClientId: '877229430819-9pc9v3qdd03ahgv7ocqqostrkk3ueuje.apps.googleusercontent.com',
    iosClientId: '877229430819-eh44g0a7r445rb170f6brhcd396vlot2.apps.googleusercontent.com',
    iosBundleId: 'com.example.chitchat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBDtDSBZhN7598paEZwzHqCf950fkHAxU0',
    appId: '1:877229430819:ios:85f6c4f2b8afda2652f996',
    messagingSenderId: '877229430819',
    projectId: 'chit-chat-21bd4',
    storageBucket: 'chit-chat-21bd4.appspot.com',
    androidClientId: '877229430819-9pc9v3qdd03ahgv7ocqqostrkk3ueuje.apps.googleusercontent.com',
    iosClientId: '877229430819-em5vbu9q4q2to22m0fvc71gbteso3h4j.apps.googleusercontent.com',
    iosBundleId: 'com.example.chitchat.RunnerTests',
  );
}
