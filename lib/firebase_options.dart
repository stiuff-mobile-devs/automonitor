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
    appId: '1:1067878525854:android:397ffacbc790e8c36b048f',
    messagingSenderId: '1067878525854',
    projectId: 'autointelligence-762bb',
    storageBucket: 'autointelligence-762bb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCWV2_bJGSyUuKmZRKdzNmCzG16LAEv-jI',
    appId: '1:1067878525854:ios:711d4c0e4a7ff6796b048f',
    messagingSenderId: '1067878525854',
    projectId: 'autointelligence-762bb',
    storageBucket: 'autointelligence-762bb.firebasestorage.app',
    androidClientId: '1067878525854-0nhoasp1o69dpqqdsudchnvpgervbvef.apps.googleusercontent.com',
    iosClientId: '1067878525854-rr7sp9p298bulfguncci87f484ce99g4.apps.googleusercontent.com',
    iosBundleId: 'br.uff.autoMonitor',
  );

}