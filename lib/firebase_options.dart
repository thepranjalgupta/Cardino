import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return ios;
    } else {
      throw UnsupportedError(
        'DefaultFirebaseOptions are not supported for this platform.',
      );
    }
  }

  // 🌐 Web config (Not used yet, placeholder values)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyCvYHLM4oafkUbZI7jkyIFPRS93E1gUfrk",
    appId: "1:367645614123:web:dummyvalue", // Replace if/when you enable web
    messagingSenderId: "367645614123",
    projectId: "cardo-b163b",
    storageBucket: "cardo-b163b.firebasestorage.app",
  );

  // 🤖 Android config (from google-services.json)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyCvYHLM4oafkUbZI7jkyIFPRS93E1gUfrk",
    appId: "1:367645614123:android:0a249c0b19392b12c10a6e",
    messagingSenderId: "367645614123",
    projectId: "cardo-b163b",
    storageBucket: "cardo-b163b.firebasestorage.app",
  );

  // 🍏 iOS config (placeholder, update when you set up iOS)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyCvYHLM4oafkUbZI7jkyIFPRS93E1gUfrk",
    appId: "1:367645614123:ios:dummyvalue", // Replace when you add iOS
    messagingSenderId: "367645614123",
    projectId: "cardo-b163b",
    storageBucket: "cardo-b163b.firebasestorage.app",
    iosBundleId: "com.cardo.cardo", // Replace with actual iOS bundle ID
  );
}
