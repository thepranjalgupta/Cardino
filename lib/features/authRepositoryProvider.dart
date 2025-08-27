import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/UserModel.dart';
import '../repo/AuthRepository.dart';
import 'firebaseAuthProvider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
});

class AuthState {
  final bool loading;
  final String? error;

  const AuthState({
    this.loading = false,
    this.error,
  });

  AuthState copyWith({bool? loading, String? error}) {
    return AuthState(
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

final authControllerProvider =
StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthController(this._ref) : super(const AuthState());

  // Future<void> signUp(String email, String password) async {
  //   state = state.copyWith(loading: true, error: null);
  //   try {
  //     await _ref.read(authRepositoryProvider).signUpWithEmail(email, password);
  //   } on FirebaseAuthException catch (e) {
  //     state = state.copyWith(error: e.message);
  //   } catch (e) {
  //     state = state.copyWith(error: e.toString());
  //   } finally {
  //     state = state.copyWith(loading: false);
  //   }
  // }

  // Future<void> signUp(String email, String password) async {
  //   state = state.copyWith(loading: true, error: null);
  //   try {
  //     await _ref.read(authRepositoryProvider).signUpWithEmail(email, password);
  //   } on FirebaseAuthException catch (e) {
  //     state = state.copyWith(error: e.message);
  //     rethrow;
  //   } catch (e) {
  //     state = state.copyWith(error: e.toString());
  //     throw FirebaseAuthException(
  //       code: 'unknown',
  //       message: 'An unknown error occurred.',
  //     );
  //   } finally {
  //     state = state.copyWith(loading: false);
  //   }
  // }



  Future<void> signUp(String name, String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _ref.read(authRepositoryProvider).signUpWithEmail(email, password, name);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(error: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'An unknown error occurred.',
      );
    } finally {
      state = state.copyWith(loading: false);
    }
  }




  // Future<void> signIn(String email, String password) async {
  //   state = state.copyWith(loading: true, error: null);
  //   try {
  //     await _ref.read(authRepositoryProvider).signInWithEmail(email, password);
  //   } on FirebaseAuthException catch (e) {
  //     state = state.copyWith(error: e.message);
  //   } catch (e) {
  //     state = state.copyWith(error: e.toString());
  //   } finally {
  //     state = state.copyWith(loading: false);
  //   }
  // }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _ref.read(authRepositoryProvider).signInWithEmail(email, password);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(error: e.message);
      rethrow; // <-- Add this!
    } catch (e) {
      state = state.copyWith(error: e.toString());
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'An unknown error occurred.',
      );
    } finally {
      state = state.copyWith(loading: false);
    }
  }



  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update(data);
  }


  Future<void> signOut() async {
    await _ref.read(authRepositoryProvider).signOut();
  }
}
