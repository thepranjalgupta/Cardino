import 'package:cardo/features/Avatar_provider.dart';
import 'package:cardo/model/business_card.dart';
import 'package:cardo/screens/ProfileScreen.dart';
import 'package:cardo/usecase/SearchCardsUseCase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../features/ocr_provider.dart';
import 'IntroScreen.dart';
import 'OcrScreen.dart';

final searchQueryProvider = StateProvider<String>((ref) => "");

class Homescreen extends ConsumerWidget {
  const Homescreen({super.key});





  //
  // Stream<List<BusinessCard>> _cardsStream() {
  //   return FirebaseFirestore.instance
  //       .collection("cards")
  //       .orderBy("createdAt", descending: true)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs
  //       .map((doc) => BusinessCard.fromFirestore(doc.data(), doc.id))
  //       .toList());
  // }


  // void _deleteCard(String id) {
  //   FirebaseFirestore.instance.collection('cards').doc(id).delete();
  // }

  void _deleteCard(String id) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cards')
        .doc(id)
        .delete();
  }

  // void _shareCard(BusinessCard card) {
  //   final content = ''' ${card.name} ${card.name} 📞 ${card.phone} ✉️ ${card
  //       .email} 🏢 ${card.address} ''';
  //   Share.share(content);
  // }
  void _shareCard(BusinessCard card) {
    final buffer = StringBuffer();

    if (card.ownerName != null && card.ownerName!.isNotEmpty) {
      buffer.writeln("👤 ${card.ownerName}");
    }

    if (card.name.isNotEmpty) {
      buffer.writeln("🏢 ${card.name}");
    }

    if (card.phone.isNotEmpty) {
      buffer.writeln("📞 ${card.phone}");
    }

    if (card.email.isNotEmpty) {
      buffer.writeln("✉️ ${card.email}");
    }

    if (card.website != null && card.website!.isNotEmpty) {
      buffer.writeln("🌐 ${card.website}");
    }

    if (card.address.isNotEmpty) {
      buffer.writeln("📍 ${card.address}");
    }

    Share.share(buffer.toString().trim());
  }

  void launchPhone(String phoneNumber) async {
    final sanitizedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri url = Uri(scheme: 'tel', path: sanitizedNumber);

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.platformDefault, // important for Android/iOS
      );
    } else {
      print('Could not launch $sanitizedNumber');
    }
  }

  void launchEmail(String email) async {
    final Uri url = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $email';
    }
  }

  Future<void> launchWebsite(String url) async {
    final Uri uri = Uri.parse(
      url.startsWith("http") ? url : "https://$url", // ensure scheme
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // opens in browser
      );
    } else {
      throw "Could not launch $uri";
    }
  }





  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final query = ref.watch(searchQueryProvider);
    final avatarUrl = ref.watch(avatarProvider);
    // Stream<List<BusinessCard>> _cardsStream() {
    //   return FirebaseFirestore.instance
    //       .collection("cards")
    //       .orderBy("createdAt", descending: true)
    //       .snapshots()
    //       .map((snapshot) => snapshot.docs
    //       .map((doc) => BusinessCard.fromFirestore(doc.data(), doc.id))
    //       .toList());
    // }
    Stream<List<BusinessCard>> userCardsStream() {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return const Stream.empty();

      return FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("cards")
          .orderBy("createdAt", descending: true)
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) => BusinessCard.fromMap(doc.data(), doc.id)).toList());
    }


    return Scaffold(
      appBar: AppBar(
        title: Padding( padding: const EdgeInsets.only(top: 50, bottom: 50), child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Icon(Icons.menu, size: 30,),
                // SizedBox(width: 10,),
                Text("Home", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),),
              ],
            ),

            // CircleAvatar(
            //   radius: screenWidth * 0.06, // Adjust the size of the circle
            //    backgroundImage: NetworkImage('https://i.redd.it/xew4tb218ktd1.jpeg'),
            // //  backgroundImage: AssetImage('assets/images/avatar.png'),
            // ),



            InkWell(
              onTap: () {
                // Trigger dropdown for profile menu
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    screenWidth - 120, // Position of the dropdown relative to screen
                    80, // Adjust the vertical position as needed
                    0,
                    0,
                  ),
                  items: [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Row(
                        children: [
                          Icon(Icons.person_3_rounded, color: Colors.amber),
                          SizedBox(width: 5),
                          Text("Profile"),
                        ],
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(Icons.logout_sharp, color: Colors.red),
                          SizedBox(width: 5),
                          Text("Logout"),
                        ],
                      ),
                    ),
                  ],
                ).then((value) async {
                  if (value == null) return; // user closed without selecting

                  switch (value) {
                    case 0:
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        );
                      }
                      break;
                    case 1:
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const IntroScreen()),
                              (route) => false, // clear history
                        );
                      }
                      break;
                  }
                });
              },
              child: CircleAvatar(
                radius: screenWidth * 0.06, // Adjust size as needed
                backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                child: avatarUrl == null
                    ? Icon(Icons.person, size: 40, color: Colors.white)
                    : null,
              ),
            ),
          ],
        )),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Cards...",
                // hintStyle: TextStyle(color: Colors.white70), // faded hint
                filled: true,
                // fillColor: Colors.grey[850], // dark background for dark theme
                prefixIcon: const Icon(Icons.search_rounded,),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),

                // Rounded corners + no border
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),

                // Focused border glow effect
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Color(0xFF6EE7F9), width: 2),
                ),

                // Enabled border
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Color(0xFF8B5CF6), width: 1),
                ),
              ),



              // decoration: InputDecoration(
              //   hintText: "Search cards...",
              //   border: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(40), // rounded corners
              //   ),
              //   prefixIcon: const Icon(Icons.search),
              // ),
              onChanged: (value) {
                ref
                    .read(searchQueryProvider.notifier)
                    .state = value;
              },
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<BusinessCard>>(
        stream: userCardsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final cards = snapshot.data ?? [];
          final filteredCards = SearchCardsUseCase()(cards, query);
          if (cards.isEmpty) {
            return const Center(child: Text('No cards saved yet'));
          }
          return ListView.builder(
            itemCount: filteredCards.length,
            itemBuilder: (context, i) {
              final c = filteredCards[i];
              return Slidable(
                key: ValueKey(c.id),

                // 👈 ensure BusinessCard has id
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.75,
                  children: [
                    SlidableAction(
                      padding: const EdgeInsets.all(16),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                      onPressed: (_) => _shareCard(c),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.share,
                      label: 'Share',
                    ),

                    // SlidableAction(
                    //   borderRadius: BorderRadius.only(topRight: Radius.circular(0),bottomRight: Radius.circular(0)),
                    //   onPressed: (_) => _deleteCard(c.id!),
                    //   backgroundColor: Colors.green,
                    //   foregroundColor: Colors.white,
                    //   icon: Icons.accessibility,
                    //   label: 'Assign',
                    // ),

                    SlidableAction(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
                      onPressed: (_) => _deleteCard(c.id!),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),

                child:
                Card(
                  margin: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4, // soft shadow
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Company / Business Name
                            Expanded(
                              child: Text(
                                c.name.isNotEmpty ? c.name : 'Unknown',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            if (c.phone.isNotEmpty)
                              IconButton(
                                onPressed: () => launchPhone(c.phone),
                                icon: const Icon(Icons.phone, color: Colors.green),
                              ),
                            if (c.email.isNotEmpty)
                              IconButton(
                                onPressed: () => launchEmail(c.email),
                                icon: const Icon(Icons.email, color: Colors.blue),
                              ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Owner Name
                        if (c.ownerName != null && c.ownerName!.isNotEmpty)
                          Row(
                            children: [
                              const Icon(Icons.person, size: 18, color: Colors.amber),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  c.ownerName!,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                        // Phone
                        if (c.phone.isNotEmpty)
                          Row(
                            children: [
                              const Icon(Icons.phone, size: 18, color: Colors.green),
                              const SizedBox(width: 6),
                              Text(c.phone),
                            ],
                          ),

                        // Email
                        if (c.email.isNotEmpty)
                          Row(
                            children: [
                              const Icon(Icons.email, size: 18, color: Colors.blue),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  c.email,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                        // Website
                        if (c.website != null && c.website!.isNotEmpty)
                          Row(
                            children: [
                              const Icon(Icons.language, size: 18, color: Colors.purple),
                              const SizedBox(width: 6),
                              Expanded(
                                child: InkWell(
                                  onTap: () => launchWebsite(c.website!),
                                  child: Text(
                                    c.website!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),

                        // Address
                        if (c.address.isNotEmpty)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on, size: 18, color: Colors.red),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  c.address,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),


              );
            },
          );
        },
      ),
      floatingActionButton: SizedBox(
        height: screenHeight * 0.08,
        width: screenWidth * 0.19,
        child: FloatingActionButton(
          backgroundColor: Color(0xFF8B5CF6),

          onPressed: () async {
            final ocrNotifier = ref.read(ocrProvider.notifier);
            final recognizedText = await ocrNotifier.pickImage(); // make pickImage return text or null

            if (recognizedText != null && recognizedText.trim().isNotEmpty) {
              //text found from img
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OcrScreen()),
              );
            } else {
              // no text found
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No text recognized, please try again.")),
              );
            }
          },
          child: const Icon(Icons.add_a_photo, size: 30, color: Colors.white,),
        ),
      ),

    );
  }
}

//
// import 'package:cardo/features/Avatar_provider.dart';
// import 'package:cardo/model/business_card.dart';
// import 'package:cardo/screens/ProfileScreen.dart';
// import 'package:cardo/usecase/SearchCardsUseCase.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../features/ocr_provider.dart';
// import 'IntroScreen.dart';
// import 'OcrScreen.dart';
//
// final searchQueryProvider = StateProvider<String>((ref) => "");
//
// class Homescreen extends ConsumerWidget {
//   const Homescreen({super.key});
//
//   void _deleteCard(String id) async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;
//
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(uid)
//         .collection('cards')
//         .doc(id)
//         .delete();
//   }
//
//   void _shareCard(BusinessCard card) {
//     final buffer = StringBuffer();
//
//     if (card.ownerName != null && card.ownerName!.isNotEmpty) {
//       buffer.writeln("👤 ${card.ownerName}");
//     }
//
//     if (card.name.isNotEmpty) {
//       buffer.writeln("🏢 ${card.name}");
//     }
//
//     if (card.phone.isNotEmpty) {
//       buffer.writeln("📞 ${card.phone}");
//     }
//
//     if (card.email.isNotEmpty) {
//       buffer.writeln("✉️ ${card.email}");
//     }
//
//     if (card.website != null && card.website!.isNotEmpty) {
//       buffer.writeln("🌐 ${card.website}");
//     }
//
//     if (card.address.isNotEmpty) {
//       buffer.writeln("📍 ${card.address}");
//     }
//
//     Share.share(buffer.toString().trim());
//   }
//
//   void launchPhone(String phoneNumber) async {
//     final sanitizedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
//     final Uri url = Uri(scheme: 'tel', path: sanitizedNumber);
//
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url, mode: LaunchMode.platformDefault);
//     } else {
//       print('Could not launch $sanitizedNumber');
//     }
//   }
//
//   void launchEmail(String email) async {
//     final Uri url = Uri(scheme: 'mailto', path: email);
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url);
//     } else {
//       throw 'Could not launch $email';
//     }
//   }
//
//   Future<void> launchWebsite(String url) async {
//     final Uri uri = Uri.parse(url.startsWith("http") ? url : "https://$url");
//
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       throw "Could not launch $uri";
//     }
//   }
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final query = ref.watch(searchQueryProvider);
//
//     // Watch the avatar provider to get the current avatar URL
//     final avatarUrl = ref.watch(avatarProvider);
//
//     Stream<List<BusinessCard>> userCardsStream() {
//       final uid = FirebaseAuth.instance.currentUser?.uid;
//       if (uid == null) return const Stream.empty();
//
//       return FirebaseFirestore.instance
//           .collection("users")
//           .doc(uid)
//           .collection("cards")
//           .orderBy("createdAt", descending: true)
//           .snapshots()
//           .map((snapshot) =>
//           snapshot.docs.map((doc) => BusinessCard.fromMap(doc.data(), doc.id)).toList());
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Padding(
//           padding: const EdgeInsets.only(top: 50, bottom: 50),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Home",
//                 style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
//               ),
//               // Display the avatar in the AppBar
//               InkWell(
//                 onTap: () {
//                   // Trigger dropdown for profile menu
//                   showMenu(
//                     context: context,
//                     position: RelativeRect.fromLTRB(
//                       screenWidth - 120, // Position of the dropdown relative to screen
//                       80, // Adjust the vertical position as needed
//                       0,
//                       0,
//                     ),
//                     items: [
//                       PopupMenuItem<int>(
//                         value: 0,
//                         child: Row(
//                           children: [
//                             Icon(Icons.person_3_rounded, color: Colors.amber),
//                             SizedBox(width: 5),
//                             Text("Profile"),
//                           ],
//                         ),
//                       ),
//                       PopupMenuItem<int>(
//                         value: 1,
//                         child: Row(
//                           children: [
//                             Icon(Icons.logout_sharp, color: Colors.red),
//                             SizedBox(width: 5),
//                             Text("Logout"),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ).then((value) async {
//                     if (value == null) return; // user closed without selecting
//
//                     switch (value) {
//                       case 0:
//                         if (context.mounted) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (_) => const ProfileScreen()),
//                           );
//                         }
//                         break;
//                       case 1:
//                         await FirebaseAuth.instance.signOut();
//                         if (context.mounted) {
//                           Navigator.pushAndRemoveUntil(
//                             context,
//                             MaterialPageRoute(builder: (_) => const IntroScreen()),
//                                 (route) => false, // clear history
//                           );
//                         }
//                         break;
//                     }
//                   });
//                 },
//                 child: CircleAvatar(
//                   radius: screenWidth * 0.06, // Adjust size as needed
//                   backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
//                   child: avatarUrl == null
//                       ? Icon(Icons.person, size: 40, color: Colors.white)
//                       : null,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(80),
//           child: Padding(
//             padding: const EdgeInsets.all(12),
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: "Search Cards...",
//                 filled: true,
//                 prefixIcon: const Icon(Icons.search_rounded),
//                 contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25),
//                   borderSide: BorderSide.none,
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25),
//                   borderSide: const BorderSide(color: Color(0xFF6EE7F9), width: 2),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25),
//                   borderSide: BorderSide(color: Color(0xFF8B5CF6), width: 1),
//                 ),
//               ),
//               onChanged: (value) {
//                 ref.read(searchQueryProvider.notifier).state = value;
//               },
//             ),
//           ),
//         ),
//       ),
//       body: StreamBuilder<List<BusinessCard>>(
//         stream: userCardsStream(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final cards = snapshot.data ?? [];
//           final filteredCards = SearchCardsUseCase()(cards, query);
//           if (cards.isEmpty) {
//             return const Center(child: Text('No cards saved yet'));
//           }
//           return ListView.builder(
//             itemCount: filteredCards.length,
//             itemBuilder: (context, i) {
//               final c = filteredCards[i];
//               return Slidable(
//                 key: ValueKey(c.id),
//                 endActionPane: ActionPane(
//                   motion: const DrawerMotion(),
//                   extentRatio: 0.75,
//                   children: [
//                     SlidableAction(
//                       padding: const EdgeInsets.all(16),
//                       borderRadius:
//                       BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
//                       onPressed: (_) => _shareCard(c),
//                       backgroundColor: Colors.blue,
//                       foregroundColor: Colors.white,
//                       icon: Icons.share,
//                       label: 'Share',
//                     ),
//                     SlidableAction(
//                       borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
//                       onPressed: (_) => _deleteCard(c.id!),
//                       backgroundColor: Colors.red,
//                       foregroundColor: Colors.white,
//                       icon: Icons.delete,
//                       label: 'Delete',
//                     ),
//                   ],
//                 ),
//                 child: Card(
//                   margin: const EdgeInsets.all(12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   elevation: 4, // soft shadow
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 c.name.isNotEmpty ? c.name : 'Unknown',
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                             if (c.phone.isNotEmpty)
//                               IconButton(
//                                 onPressed: () => launchPhone(c.phone),
//                                 icon: const Icon(Icons.phone, color: Colors.green),
//                               ),
//                             if (c.email.isNotEmpty)
//                               IconButton(
//                                 onPressed: () => launchEmail(c.email),
//                                 icon: const Icon(Icons.email, color: Colors.blue),
//                               ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         if (c.ownerName != null && c.ownerName!.isNotEmpty)
//                           Row(
//                             children: [
//                               const Icon(Icons.person, size: 18, color: Colors.amber),
//                               const SizedBox(width: 6),
//                               Expanded(
//                                 child: Text(
//                                   c.ownerName!,
//                                   style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: SizedBox(
//         height: screenHeight * 0.08,
//         width: screenWidth * 0.19,
//         child: FloatingActionButton(
//           backgroundColor: const Color(0xFF8B5CF6),
//           onPressed: () async {
//             final ocrNotifier = ref.read(ocrProvider.notifier);
//             final recognizedText = await ocrNotifier.pickImage();
//
//             if (recognizedText != null && recognizedText.trim().isNotEmpty) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const OcrScreen()),
//               );
//             } else {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("No text recognized, please try again.")),
//               );
//             }
//           },
//           child: const Icon(Icons.add_a_photo, size: 30, color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
