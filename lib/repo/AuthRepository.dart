// import 'package:firebase_auth/firebase_auth.dart';
//
//
// class AuthRepository {
//   final FirebaseAuth _auth;
//   const AuthRepository(this._auth);
//
//
//   Stream<User?> get authState => _auth.authStateChanges();
//
//
//   // Future<User?> signUpWithEmail(String email, String password) async {
//   //   final cred = await _auth.createUserWithEmailAndPassword(
//   //     email: email,
//   //     password: password,
//   //   );
//   //   return cred.user;
//   // }
//   // verification
//   Future<User?> signUpWithEmail(String email, String password) async {
//     final cred = await _auth.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//
//     // Send verification email
//     await cred.user?.sendEmailVerification();
//
//     return cred.user;
//   }
//
//
//   Future<User?> signInWithEmail(String email, String password) async {
//     final cred = await _auth.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//     return cred.user;
//   }
//
//
//
//   Future<void> signOut() => _auth.signOut();
// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/UserModel.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  // Initialize _firestore in constructor
  AuthRepository(this._auth) : _firestore = FirebaseFirestore.instance;

  Stream<User?> get authState => _auth.authStateChanges();

  Future<User?> signUpWithEmail(String email, String password, String name) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await cred.user?.sendEmailVerification();

    final user = UserModel(
      uid: cred.user!.uid,
      email: email,
      name: name, // Include name here
    );

    await _firestore.collection('users').doc(user.uid).set(user.toMap());

    return cred.user;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return cred.user;
  }

  Future<void> signOut() => _auth.signOut();
}
