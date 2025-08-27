import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../model/business_card.dart';
import '../util/parser.dart';

// Provider
final ocrProvider =
StateNotifierProvider<OcrNotifier, OcrState>((ref) => OcrNotifier());

// State class
class OcrState {
  final String? id;
  final File? image;
  final String recognizedText;
  final bool isLoading;

  OcrState({
    this.id,
    this.image,
    this.recognizedText = '',
    this.isLoading = false,
  });

  OcrState copyWith({
    File? image,
    String? recognizedText,
    bool? isLoading,
  }) {
    return OcrState(
      image: image ?? this.image,
      recognizedText: recognizedText ?? this.recognizedText,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Notifier
class OcrNotifier extends StateNotifier<OcrState> {
  OcrNotifier() : super(OcrState());

  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();


  /// Pick an image from camera and run OCR
  // Future<void> pickImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.camera);
  //   if (pickedFile != null) {
  //     state = state.copyWith(image: File(pickedFile.path));
  //     await performOCR();
  //   }
  //
  // }
  Future<String?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      state = state.copyWith(image: File(pickedFile.path));
      await performOCR();
    }
    return state.recognizedText.isNotEmpty ? state.recognizedText : null;
  }

  /// Perform OCR on the selected image
  Future<void> performOCR() async {
    if (state.image == null) return;
    state = state.copyWith(isLoading: true);

    final inputImage = InputImage.fromFile(state.image!);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

    state = state.copyWith(
      recognizedText: recognizedText.text,
      isLoading: false,
    );
  }


  /// Save OCR result to Firestore (optional)
  // Future<void> saveToFirestore() async {
  //   if (state.recognizedText.isEmpty) return;
  //
  //   // 👇
  //   await FirebaseFirestore.instance.collection("cards").add({
  //     "text": state.recognizedText,
  //     "timestamp": FieldValue.serverTimestamp(),
  //   });
  //
  // }

  /// Save OCR result to Firestore with values from controllers
  // Future<void> saveToFirestore({
  //   required String name,
  //   required String phone,
  //   required String email,
  //   required String address,
  // }) async {
  //   await FirebaseFirestore.instance.collection("cards").add({
  //     "name": name,
  //     "phone": phone,
  //     "email": email,
  //     "address": address,
  //     "timestamp": FieldValue.serverTimestamp(),
  //   });
  // }


  //
  // Future<void> saveToFirestore() async {
  //   if (state.recognizedText.isEmpty) return;
  //
  //   final card = parseBusinessCard(state.recognizedText);
  //
  //   await FirebaseFirestore.instance.collection("cards").add(card.toMap());
  // }
  //
  // Future<void> saveToFirestore([BusinessCard? card]) async {
  //   try {
  //     final cardToSave = card ?? parseBusinessCard(state.recognizedText);
  //
  //     if (cardToSave.name.isEmpty &&
  //         cardToSave.phone.isEmpty &&
  //         cardToSave.email.isEmpty &&
  //         cardToSave.address.isEmpty &&
  //         (cardToSave.ownerName ?? '').isEmpty &&
  //         (cardToSave.website ?? '').isEmpty) {
  //       debugPrint("⚠️ No useful model found, skipping save.");
  //       return;
  //     }
  //
  //     await FirebaseFirestore.instance.collection("cards").add({
  //       "name": cardToSave.name,
  //       "ownerName": cardToSave.ownerName,
  //       "phone": cardToSave.phone,
  //       "email": cardToSave.email,
  //       "website": cardToSave.website,
  //       "address": cardToSave.address,
  //       "rawText": cardToSave.rawText,
  //       "createdAt": FieldValue.serverTimestamp(),
  //     });
  //
  //     debugPrint("✅ Card saved successfully!");
  //   } catch (e, st) {
  //     debugPrint("❌ Error saving card: $e");
  //     debugPrint("Stack: $st");
  //   }
  // }

  // Future<void> saveToFirestore([BusinessCard? card]) async {
  //   try {
  //     final uid = FirebaseAuth.instance.currentUser?.uid;
  //     if (uid == null) {
  //       debugPrint("⚠️ User not logged in, cannot save.");
  //       return;
  //     }
  //
  //     final cardToSave = card ?? parseBusinessCard(state.recognizedText);
  //
  //     if (cardToSave.name.isEmpty &&
  //         cardToSave.phone.isEmpty &&
  //         cardToSave.email.isEmpty &&
  //         cardToSave.address.isEmpty &&
  //         (cardToSave.ownerName ?? '').isEmpty &&
  //         (cardToSave.website ?? '').isEmpty) {
  //       debugPrint("⚠️ No useful model found, skipping save.");
  //       return;
  //     }
  //
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(uid)
  //         .collection("cards")
  //         .add({
  //       "name": cardToSave.name,
  //       "ownerName": cardToSave.ownerName,
  //       "phone": cardToSave.phone,
  //       "email": cardToSave.email,
  //       "website": cardToSave.website,
  //       "address": cardToSave.address,
  //       "rawText": cardToSave.rawText,
  //       "createdAt": FieldValue.serverTimestamp(),
  //     });
  //
  //     debugPrint("✅ Card saved successfully!");
  //   } catch (e, st) {
  //     debugPrint("❌ Error saving card: $e");
  //     debugPrint("Stack: $st");
  //   }
  // }
  //
  // Future<void> deleteCard(String docId) async {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;
  //   if (uid == null) {
  //     debugPrint("⚠️ No user logged in, cannot delete card.");
  //     return;
  //   }
  //
  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(uid)
  //       .collection("cards")
  //       .doc(docId)
  //       .delete();
  //
  //   debugPrint("🗑️ Card deleted successfully!");
  // }



  // Future<void> deleteCard(String docId) async {
  //   await FirebaseFirestore.instance
  //       .collection("cards")
  //       .doc(docId)
  //       .delete();
  // }



  Future<void> saveToFirestore([BusinessCard? card]) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        debugPrint("⚠️ No user logged in.");
        return;
      }

      if (!user.emailVerified) {
        debugPrint("⚠️ User email not verified, skipping save.");
        return;
      }

      final cardToSave = card ?? parseBusinessCard(state.recognizedText);

      if (cardToSave.name.isEmpty &&
          cardToSave.phone.isEmpty &&
          cardToSave.email.isEmpty &&
          cardToSave.address.isEmpty &&
          (cardToSave.ownerName ?? '').isEmpty &&
          (cardToSave.website ?? '').isEmpty) {
        debugPrint("⚠️ No useful model found, skipping save.");
        return;
      }

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("cards")
          .add({
        "name": cardToSave.name,
        "ownerName": cardToSave.ownerName,
        "phone": cardToSave.phone,
        "email": cardToSave.email,
        "website": cardToSave.website,
        "address": cardToSave.address,
        "rawText": cardToSave.rawText,
        "createdAt": FieldValue.serverTimestamp(),
      });

      debugPrint("✅ Card saved successfully!");
    } catch (e, st) {
      debugPrint("❌ Error saving card: $e");
      debugPrint("Stack: $st");
    }
  }





  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }
}
