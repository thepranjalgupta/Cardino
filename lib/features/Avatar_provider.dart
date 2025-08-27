import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class AvatarNotifier extends StateNotifier<String?> {
//   AvatarNotifier() : super(null) {
//     _loadAvatar(); // Load avatar on creation
//   }
//
//   Future<void> _loadAvatar() async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;
//     final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
//     state = doc.data()?['avatarUrl'] as String?;
//   }
//
//   Future<void> updateAvatar(String newUrl) async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;
//
//     // Update avatarUrl in Firestore for current user only
//     await FirebaseFirestore.instance.collection('users').doc(uid).update({
//       'avatarUrl': newUrl,
//     });
//
//     // Update local state
//     state = newUrl;
//   }
// }
//
// final avatarProvider = StateNotifierProvider<AvatarNotifier, String?>((ref) {
//   return AvatarNotifier();
// });

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvatarNotifier extends StateNotifier<String?> {
  AvatarNotifier() : super(null) {
    _loadAvatar(); // Load avatar on creation
  }

  // Load the avatar for the current user
  Future<void> _loadAvatar() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;  // No user logged in

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    state = doc.data()?['avatarUrl'] as String?;
  }

  // Update the avatar for the current user
  Future<void> updateAvatar(String newUrl) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Update avatarUrl in Firestore for the current user only
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'avatarUrl': newUrl,
    });

    // Update local state
    state = newUrl;
  }
}

final avatarProvider = StateNotifierProvider<AvatarNotifier, String?>((ref) {
  return AvatarNotifier();
});


