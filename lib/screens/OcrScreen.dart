// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../features/ocr_provider.dart';
// import '../model/util/parser.dart';
//
// class OcrScreen extends ConsumerWidget {
//   const OcrScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final ocrState = ref.watch(ocrProvider);
//     final card = ocrState.recognizedText.isNotEmpty
//         ? parseBusinessCard(ocrState.recognizedText)
//         : null;
//     return Scaffold(
//       appBar: AppBar(title: Text("Scan Card")),
//       floatingActionButton: SizedBox(
//         height: screenHeight * 0.08,
//         width: screenWidth * 0.35,
//         child: FloatingActionButton(
//           backgroundColor: Color(0xFF8B5CF6),
//           onPressed: () {
//             ref.read(ocrProvider.notifier).pickImage();
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Row(
//               children: [
//                 Icon(Icons.camera, size: 30, color: Colors.white),
//                 SizedBox(width: 5,),
//                 Text("Scan Again"),
//
//               ],
//             ),
//           )
//           //Icon(Icons.camera, size: 30, color: Colors.white),
//         ),
//       ),
//       body: Column(
//         children: [
//           if (ocrState.image == null) Center(child:  Text("Add Card Form below Button"),),
//           if (ocrState.image != null)
//             Container(
//               width: screenWidth * 1,
//               margin: EdgeInsets.symmetric(horizontal: 20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Image.file(ocrState.image!, height: screenHeight * 0.4,),
//                   SizedBox(height: screenHeight * 0.03),
//                   Text("🧑 Name:-  ${card?.name}", style: TextStyle(fontSize: 16)),
//                   // SizedBox(width: 20,),
//                   Text(
//                     "📱 Mobile Number:-  ${card?.phone}",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   Text("✉️ Email:-  ${card?.email}", style: TextStyle(fontSize: 16)),
//                   Text(
//                     "📍 Address:-  ${card?.address}",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: screenHeight * 0.03),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           ref.read(ocrProvider.notifier).saveToFirestore();
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text("✅ ${card?.name}'s Card Saved!")),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
//                           backgroundColor: Color(0xFF1eaeb6), // button color
//                           foregroundColor: Colors.white, // text color
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30), // rounded corners
//                           ),
//                           elevation: 6, // shadow
//                         ),
//                         child: const Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.save, size: 22, color: Colors.white), // save icon
//                             SizedBox(width: 8),
//                             Text(
//                               "Save",
//                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       )
//
//                       // ElevatedButton(
//                       //   onPressed: () {
//                       //     ref.read(ocrProvider.notifier).saveToFirestore();
//                       //   },
//                       //   child: Text("Save to Firestore"),
//                       // ),
//                     ],
//                   ),
//                 ],
//
//               ),
//             ),
//
//           if (ocrState.isLoading) CircularProgressIndicator(),
//
//           // ElevatedButton(
//           //   onPressed: () {
//           //     ref.read(ocrProvider.notifier).pickImage();
//           //   },
//           //   child: Text("Pick Image"),
//           // ),
//
//           // ElevatedButton(
//           //   onPressed: () {
//           //     Navigator.push(
//           //       context,
//           //       MaterialPageRoute(
//           //         builder: (context) => const BusinessCardListScreen(),
//           //       ),
//           //     );
//           //   },
//           //   child: const Text("📇 View Saved Cards"),
//           // ),
//         ],
//       ),
//     );
//   }
// }

//This is with animation// no edidatble  filed

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../features/ocr_provider.dart';
// import '../model/util/parser.dart';
//
// class OcrScreen extends ConsumerStatefulWidget {
//   const OcrScreen({super.key});
//
//   @override
//   ConsumerState<OcrScreen> createState() => _OcrScreenState();
// }
//
// class _OcrScreenState extends ConsumerState<OcrScreen> {
//   bool _isSaved = false; // track animation state
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final ocrState = ref.watch(ocrProvider);
//
//     final card = ocrState.recognizedText.isNotEmpty
//         ? parseBusinessCard(ocrState.recognizedText)
//         : null;
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Scan Card")),
//       floatingActionButton: SizedBox(
//         height: screenHeight * 0.08,
//         width: screenWidth * 0.35,
//         child: FloatingActionButton(
//           backgroundColor: const Color(0xFF8B5CF6),
//           onPressed: () {
//             ref.read(ocrProvider.notifier).pickImage();
//           },
//           child: const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.camera, size: 30, color: Colors.white),
//               SizedBox(width: 5),
//               Text("Scan Again"),
//             ],
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           if (ocrState.image == null)
//             const Center(child: Text("📸 Scan a card using the button below")),
//           if (ocrState.image != null)
//             Expanded(
//               child: Column(
//                 children: [
//                   Image.file(
//                     ocrState.image!,
//                     height: screenHeight * 0.35,
//                     fit: BoxFit.cover,
//                   ),
//                   const SizedBox(height: 20),
//
//                   if (card != null)
//                     AnimatedSlide(
//                       duration: const Duration(milliseconds: 500),
//                       curve: Curves.easeInOut,
//                       offset: _isSaved ? const Offset(0, 2) : Offset.zero, // slide down
//                       child: AnimatedOpacity(
//                         duration: const Duration(milliseconds: 500),
//                         opacity: _isSaved ? 0 : 1,
//                         child: Card(
//                           margin: const EdgeInsets.all(12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           elevation: 4,
//                           child: Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   card.name.isNotEmpty ? card.name : "Unknown",
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 if (card.ownerName != null &&
//                                     card.ownerName!.isNotEmpty)
//                                   Text("👤 ${card.ownerName}"),
//                                 if (card.phone.isNotEmpty)
//                                   Text("📞 ${card.phone}"),
//                                 if (card.email.isNotEmpty)
//                                   Text("✉️ ${card.email}"),
//                                 if (card.website != null &&
//                                     card.website!.isNotEmpty)
//                                   Text("🌐 ${card.website}"),
//                                 if (card.address.isNotEmpty)
//                                   Text("📍 ${card.address}"),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//
//                   const SizedBox(height: 20),
//
//                   ElevatedButton.icon(
//                     onPressed: () async {
//                       ref.read(ocrProvider.notifier).saveToFirestore();
//
//                       setState(() => _isSaved = true);
//
//                       // wait for animation before navigating back
//                       await Future.delayed(const Duration(milliseconds: 600));
//                       if (mounted) Navigator.pop(context);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 28, vertical: 14),
//                       backgroundColor: const Color(0xFF1eaeb6),
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       elevation: 6,
//                     ),
//                     icon: const Icon(Icons.save, size: 22),
//                     label: const Text(
//                       "Save",
//                       style: TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//           if (ocrState.isLoading) const CircularProgressIndicator(),
//         ],
//       ),
//     );
//   }
// }
//
//

//Without Image

//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../features/ocr_provider.dart';
// import '../model/business_card.dart';
// import '../model/util/parser.dart';
//  // your OcrNotifier
//
// class OcrScreen extends ConsumerStatefulWidget {
//   const OcrScreen({super.key});
//
//   @override
//   ConsumerState<OcrScreen> createState() => _OcrResultScreenState();
// }
//
// class _OcrResultScreenState extends ConsumerState<OcrScreen> {
//   late TextEditingController nameCtrl;
//   late TextEditingController ownerCtrl;
//   late TextEditingController phoneCtrl;
//   late TextEditingController emailCtrl;
//   late TextEditingController websiteCtrl;
//   late TextEditingController addressCtrl;
//
//   @override
//   void initState() {
//     super.initState();
//     final recognizedText = ref.read(ocrProvider).recognizedText;
//
//     final parsed = parseBusinessCard(recognizedText);
//
//     nameCtrl = TextEditingController(text: parsed.name);
//     ownerCtrl = TextEditingController(text: parsed.ownerName ?? '');
//     phoneCtrl = TextEditingController(text: parsed.phone);
//     emailCtrl = TextEditingController(text: parsed.email);
//     websiteCtrl = TextEditingController(text: parsed.website ?? '');
//     addressCtrl = TextEditingController(text: parsed.address);
//   }
//
//   @override
//   void dispose() {
//     nameCtrl.dispose();
//     ownerCtrl.dispose();
//     phoneCtrl.dispose();
//     emailCtrl.dispose();
//     websiteCtrl.dispose();
//     addressCtrl.dispose();
//     super.dispose();
//   }
//
//   void _saveCard() async {
//     final card = BusinessCard(
//       id: "", // Firestore will assign
//       name: nameCtrl.text.trim(),
//       ownerName: ownerCtrl.text.trim(),
//       phone: phoneCtrl.text.trim(),
//       email: emailCtrl.text.trim(),
//       website: websiteCtrl.text.trim(),
//       address: addressCtrl.text.trim(),
//       rawText: ref.read(ocrProvider).recognizedText,
//     );
//
//     await ref.read(ocrProvider.notifier).saveToFirestore(card);
//
//     if (mounted) {
//       Navigator.of(context).pop(); // go back to home after saving
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Edit Card")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Company / Business Name")),
//               TextField(controller: ownerCtrl, decoration: const InputDecoration(labelText: "Owner Name")),
//               TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "Phone")),
//               TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
//               TextField(controller: websiteCtrl, decoration: const InputDecoration(labelText: "Website")),
//               TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: "Address")),
//               const SizedBox(height: 20),
//               ElevatedButton.icon(
//                 onPressed: _saveCard,
//                 icon: const Icon(Icons.save),
//                 label: const Text("Save"),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//

import 'dart:io';
import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/ocr_provider.dart';
import '../model/business_card.dart';
import '../util/parser.dart';

class OcrScreen extends ConsumerStatefulWidget {
  const OcrScreen({super.key});

  @override
  ConsumerState<OcrScreen> createState() => _OcrScreenState();
}

class _OcrScreenState extends ConsumerState<OcrScreen> {
  bool _isSaved = false; // track animation state

  // controllers for editable fields
  final nameCtrl = TextEditingController();
  final ownerCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    ownerCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    websiteCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final ocrState = ref.watch(ocrProvider);

    final parsedCard = ocrState.recognizedText.isNotEmpty
        ? parseBusinessCard(ocrState.recognizedText)
        : null;

    // populate controllers only once when card is parsed
    if (parsedCard != null && nameCtrl.text.isEmpty) {
      nameCtrl.text = parsedCard.name;
      ownerCtrl.text = parsedCard.ownerName ?? "";
      phoneCtrl.text = parsedCard.phone;
      emailCtrl.text = parsedCard.email;
      websiteCtrl.text = parsedCard.website ?? "";
      addressCtrl.text = parsedCard.address;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Scan Card")),

      body: SingleChildScrollView(
        child: Column(
          children: [
            if (ocrState.image == null)
              const Center(
                child: Text("📸 Scan a card using the button below"),
              ),
            if (ocrState.image != null)
              Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.file(
                    ocrState.image!,
                    height: screenHeight * 0.30,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),

                  if (parsedCard != null)
                    AnimatedSlide(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      offset: _isSaved ? const Offset(0, 2) : Offset.zero,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: _isSaved ? 0 : 1,
                        child: Card(
                          margin: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildField("Name", nameCtrl),
                                _buildField("Owner", ownerCtrl),
                                _buildField("Phone", phoneCtrl),
                                _buildField("Email", emailCtrl),
                                _buildField("Website", websiteCtrl),
                                _buildField(
                                  "Address",
                                  addressCtrl,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  //  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      left: 20,
                      bottom: 50,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            final card = BusinessCard(
                              id: "",
                              name: nameCtrl.text.trim(),
                              ownerName: ownerCtrl.text.trim(),
                              phone: phoneCtrl.text.trim(),
                              email: emailCtrl.text.trim(),
                              website: websiteCtrl.text.trim(),
                              address: addressCtrl.text.trim(),
                              rawText: ocrState.recognizedText,
                            );

                            await ref
                                .read(ocrProvider.notifier)
                                .saveToFirestore(card);

                            setState(() => _isSaved = true);

                            await Future.delayed(
                              const Duration(milliseconds: 600),
                            );
                            if (mounted) Navigator.pop(context);





                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     content: Text('${nameCtrl.text} saved successfully!'),
                            //     backgroundColor: Colors.green,
                            //     duration: const Duration(seconds: 2),
                            //     behavior: SnackBarBehavior.floating,
                            //     margin: const EdgeInsets.only(bottom: 80, left: 20, right: 20), // lifts it above FAB
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(12),
                            //     ),
                            //   ),
                            // );
                            // showDialog(
                            //   context: context,
                            //   builder: (context) => AlertDialog(
                            //     title: const Text("Success"),
                            //     content: const Text("Card saved successfully ✅"),
                            //     actions: [
                            //       TextButton(
                            //         onPressed: () => Navigator.pop(context),
                            //         child: const Text("OK"),
                            //       ),
                            //     ],
                            //   ),
                            // );

                            Flushbar(
                              margin: const EdgeInsets.all(12),
                              borderRadius: BorderRadius.circular(12),
                              backgroundGradient: const LinearGradient(
                                colors: [Color(0xFF8B5CF6), Color(0xFF6EE7F9)],  // teal-cyan gradient
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadows: [
                                BoxShadow(
                                  color: Color(0xA86EE7F9),
                                  offset: const Offset(0, 3),
                                  blurRadius: 8,
                                ),
                              ],
                              titleText: const Text(
                                "Saved!",
                                style: TextStyle(
                                  // color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              messageText: Text(
                                "${nameCtrl.text}'s Card Saved Successfully.",
                                style: const TextStyle(
                                  // color: Colors.white70,
                                  fontSize: 15,
                                ),
                              ),
                              duration: const Duration(seconds: 3),
                              flushbarPosition: FlushbarPosition.TOP,
                              icon: const Icon(Icons.check_circle, color: Colors.white, size: 28),
                              animationDuration: const Duration(milliseconds: 400),
                            ).show(context);
                            await Future.delayed(const Duration(milliseconds: 600));
                            if (mounted) Navigator.pop(context);

                            // showGeneralDialog(
                            //   context: context,
                            //   barrierDismissible: true,
                            //   barrierLabel: '',
                            //   transitionDuration: const Duration(milliseconds: 400),
                            //   pageBuilder: (context, anim1, anim2) {
                            //     return const SizedBox.shrink();
                            //   },
                            //   transitionBuilder: (context, anim1, anim2, child) {
                            //     return BackdropFilter(
                            //       filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // blur background
                            //       child: Transform.scale(
                            //         scale: anim1.value,
                            //         child: Opacity(
                            //           opacity: anim1.value,
                            //           child: AlertDialog(
                            //             shape: RoundedRectangleBorder(
                            //               borderRadius: BorderRadius.circular(20),
                            //             ),
                            //             contentPadding: const EdgeInsets.all(24),
                            //             title: Column(
                            //               mainAxisSize: MainAxisSize.min,
                            //               children: [
                            //                 Container(
                            //                   padding: const EdgeInsets.all(18),
                            //                   decoration: const BoxDecoration(
                            //                     color: Colors.green,
                            //                     shape: BoxShape.circle,
                            //                   ),
                            //                   child: const Icon(Icons.check, color: Colors.white, size: 40),
                            //                 ),
                            //                 const SizedBox(height: 16),
                            //                 const Text(
                            //                   "Saved!",
                            //                   style: TextStyle(
                            //                     fontSize: 22,
                            //                     fontWeight: FontWeight.bold,
                            //                     color: Colors.black87,
                            //                   ),
                            //                 ),
                            //                 const SizedBox(height: 8),
                            //                 Text(
                            //                   "${nameCtrl.text.trim()} saved successfully 🎉",
                            //                   textAlign: TextAlign.center,
                            //                   style: const TextStyle(fontSize: 16, color: Colors.black54),
                            //                 ),
                            //               ],
                            //             ),
                            //             actionsAlignment: MainAxisAlignment.center,
                            //             actions: [
                            //               ElevatedButton(
                            //                 style: ElevatedButton.styleFrom(
                            //                   backgroundColor: const Color(0xFF1eaeb6),
                            //                   shape: RoundedRectangleBorder(
                            //                     borderRadius: BorderRadius.circular(30),
                            //                   ),
                            //                   padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                            //                 ),
                            //                 onPressed: () => Navigator.pop(context),
                            //                 child: const Text("OK", style: TextStyle(fontSize: 16)),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // );
                            //
                            // await Future.delayed(const Duration(milliseconds: 800));
                            // if (mounted) Navigator.pop(context);

                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 14,
                            ),
                            backgroundColor: const Color(0xFF1eaeb6),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 6,
                          ),
                          icon: const Icon(Icons.save, size: 22),
                          label: const Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            if (ocrState.isLoading) const CircularProgressIndicator(),
          ],
        ),
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

  Widget _buildField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
