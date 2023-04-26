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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCoB3pDex4akJ5o4ZOKYIqpl3xau2qZMqA',
    appId: '1:395268185816:web:ada540ad6168081c44c1ad',
    messagingSenderId: '395268185816',
    projectId: 'bukkunglist',
    authDomain: 'bukkunglist.firebaseapp.com',
    storageBucket: 'bukkunglist.appspot.com',
    measurementId: 'G-DT9T9YWCQB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCpqmtWVVqH0zZQftdy8-NkyCQO50ayvh0',
    appId: '1:395268185816:android:5ed06c5b0d8594a844c1ad',
    messagingSenderId: '395268185816',
    projectId: 'bukkunglist',
    storageBucket: 'bukkunglist.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyADAEe2iXR1s0iFY3Ag6dClrB6zs6LWSDA',
    appId: '1:395268185816:ios:61bfcdebfbb9547444c1ad',
    messagingSenderId: '395268185816',
    projectId: 'bukkunglist',
    storageBucket: 'bukkunglist.appspot.com',
    iosClientId: '395268185816-oh3kqdh07vcahvg75t6fj5j4ial3gsn9.apps.googleusercontent.com',
    iosBundleId: 'com.example.coupleToDoListApp',
  );
}
