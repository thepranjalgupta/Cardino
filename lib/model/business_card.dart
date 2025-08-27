// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class BusinessCard {
//   final String id;
//   final String name;
//   // final String company;
//   final String phone;
//   final String email;
//   final String address;
//   final String rawText;
//   final String? ownerName;
//   final String? website;
//
//   BusinessCard({
//     required this.id,
//     required this.name,
//     // required this.company,
//     required this.phone,
//     required this.email,
//     required this.address,
//     required this.rawText,
//     this.ownerName,
//     this.website
//   });
//
//   factory BusinessCard.fromFirestore(
//       Map<String, dynamic> model, String documentId) {
//     return BusinessCard(
//       id: documentId,
//       name: model['name'] ?? '',
//       ownerName: model['ownerName'],
//       phone: model['phone'] ?? '',
//       email: model['email'] ?? '',
//       website: model['website'],
//       address: model['address'] ?? '',
//       rawText: model['rawText'],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'ownerName': ownerName,
//       'phone': phone,
//       'email': email,
//       'website': website,
//       'address': address,
//       'rawText': rawText,
//     };
//   }
// }
//
//   // Map<String, dynamic> toMap() {
//   //   return {
//   //     "name": name,
//   //     // "company": company,
//   //     "phone": phone,
//   //     "email": email,
//   //     "address": address,
//   //     "rawText": rawText,
//   //     "ownerName": ownerName,
//   //     "website": website,
//   //     "timestamp": FieldValue.serverTimestamp(),
//   //   };
//   // }
//
//   // factory BusinessCard.fromFirestore(DocumentSnapshot doc) {
//   //   final model = doc.model() as Map<String, dynamic>;
//   //   return BusinessCard(
//   //     id: doc.id,
//   //     name: model['name'] ?? '',
//   //     // company: model['company'] ?? '',
//   //     phone: model['phone'] ?? '',
//   //     email: model['email'] ?? '',
//   //     address: model['address'] ?? '',
//   //     rawText: model['rawText'] ?? '',
//   //     ownerName: model['ownerName'],
//   //     website: model['website'],
//   //   );
//   // }
//
// //}


import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessCard {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String rawText;
  final String? ownerName;
  final String? website;

  BusinessCard({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.rawText,
    this.ownerName,
    this.website,
  });

  /// ✅ When you already have a Map + docId
  factory BusinessCard.fromMap(Map<String, dynamic> data, String documentId) {
    return BusinessCard(
      id: documentId,
      name: data['name'] ?? '',
      ownerName: data['ownerName'],
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      website: data['website'],
      address: data['address'] ?? '',
      rawText: data['rawText'] ?? '',
    );
  }

  /// ✅ When you fetch a Firestore document directly
  factory BusinessCard.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BusinessCard.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ownerName': ownerName,
      'phone': phone,
      'email': email,
      'website': website,
      'address': address,
      'rawText': rawText,
    };
  }
}
