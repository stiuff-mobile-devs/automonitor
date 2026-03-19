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
    apiKey: 'AIzaSyCtrubv0jIRVTLfkNAtcm9YGu_Zde9igig',
    appId: '1:1067878525854:web:1aabffea929f9ec16b048f',
    messagingSenderId: '1067878525854',
    projectId: 'autointelligence-762bb',
    authDomain: 'autointelligence-762bb.firebaseapp.com',
    storageBucket: 'autointelligence-762bb.firebasestorage.app',
    measurementId: 'G-PMRM7E85BJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAR3qE-edgsUKBVZNf6WpURz_wv2vXal-Q',
    appId: '1:1067878525854:android:00064b15ca6bfa876b048f',
    messagingSenderId: '1067878525854',
    projectId: 'autointelligence-762bb',
    storageBucket: 'autointelligence-762bb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCWV2_bJGSyUuKmZRKdzNmCzG16LAEv-jI',
    appId: '1:1067878525854:ios:9bcc123c78b24b1a6b048f',
    messagingSenderId: '1067878525854',
    projectId: 'autointelligence-762bb',
    storageBucket: 'autointelligence-762bb.firebasestorage.app',
    androidClientId: '1067878525854-hv1r1ljcf9bo8na1uiilsk2t4scrm5a0.apps.googleusercontent.com',
    iosClientId: '1067878525854-dghmnf5nt15hv1t4n0p3e0sfgmhjc8hg.apps.googleusercontent.com',
    iosBundleId: 'br.uff.sti.automonitor',
  );

}