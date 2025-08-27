// // import 'dart:math';
// // import 'dart:ui';
// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// //
// // import '../model/UserModel.dart';
// //
// // class ProfileScreen extends ConsumerStatefulWidget {
// //   const ProfileScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   _ProfileScreenState createState() => _ProfileScreenState();
// // }
// //
// // class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
// //   final TextEditingController _nameController = TextEditingController();
// //   final TextEditingController _passwordController = TextEditingController();
// //   final TextEditingController _currentPasswordController = TextEditingController();
// //
// //   bool _isUpdating = false; // Add this at the top of your State class
// //
// //
// //   late final AnimationController _animationController;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadUserProfile();
// //
// //     _animationController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(seconds: 6),
// //     )..repeat(reverse: true);
// //   }
// //
// //   @override
// //   void dispose() {
// //     _nameController.dispose();
// //     _passwordController.dispose();
// //     _currentPasswordController.dispose();
// //     _animationController.dispose();
// //     super.dispose();
// //   }
// //
// //   Future<void> _loadUserProfile() async {
// //     final user = FirebaseAuth.instance.currentUser;
// //     if (user != null) {
// //       final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
// //       if (userDoc.exists) {
// //         final userModel = UserModel.fromMap(userDoc.data()!);
// //         _nameController.text = userModel.name ?? '';
// //       }
// //     }
// //   }
// //
// //   Future<void> _updateProfile() async {
// //     final user = FirebaseAuth.instance.currentUser;
// //
// //     if (user != null) {
// //       final name = _nameController.text.trim();
// //       final password = _passwordController.text.trim();
// //       final currentPassword = _currentPasswordController.text.trim();
// //
// //       try {
// //         if (password.isNotEmpty) {
// //           if (currentPassword.isEmpty) {
// //             _showSnackBar('Please enter your current password to update it');
// //             return;
// //           }
// //
// //           final cred = EmailAuthProvider.credential(
// //             email: user.email!,
// //             password: currentPassword,
// //           );
// //           await user.reauthenticateWithCredential(cred);
// //           await user.updatePassword(password);
// //         }
// //
// //         await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
// //           'name': name,
// //         });
// //
// //         _showSnackBar('Profile updated successfully');
// //       } catch (e) {
// //         _showSnackBar('Error: ${e.toString()}');
// //       }
// //     } else {
// //       _showSnackBar('No user found');
// //     }
// //   }
// //
// //   void _showSnackBar(String message) {
// //     final isDark = Theme.of(context).brightness == Brightness.dark;
// //     final snackBar = SnackBar(
// //       behavior: SnackBarBehavior.floating,
// //       margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
// //       backgroundColor: isDark
// //           ? Colors.black.withOpacity(0.85)
// //           : Colors.white.withOpacity(0.9),
// //       elevation: 10,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(16),
// //         side: BorderSide(
// //           color: isDark ? Colors.cyanAccent : Colors.indigo,
// //           width: 1.5,
// //         ),
// //       ),
// //       content: Text(
// //         message,
// //         style: TextStyle(
// //           color: isDark ? Colors.cyanAccent.shade100 : Colors.indigo.shade900,
// //           fontWeight: FontWeight.w600,
// //           fontSize: 16,
// //         ),
// //       ),
// //     );
// //
// //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final user = FirebaseAuth.instance.currentUser;
// //     final theme = Theme.of(context);
// //     final isDark = theme.brightness == Brightness.dark;
// //
// //     return Scaffold(
// //       backgroundColor: Colors.black,
// //       body: Stack(
// //         fit: StackFit.expand,
// //         children: [
// //           AnimatedBuilder(
// //             animation: _animationController,
// //             builder: (context, _) {
// //               final progress = _animationController.value;
// //               return CustomPaint(
// //                 painter: _BlobPainter(progress, isDark),
// //               );
// //             },
// //           ),
// //           Center(
// //             child: ClipRRect(
// //               borderRadius: BorderRadius.circular(24),
// //               child: BackdropFilter(
// //                 filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
// //                 child: Container(
// //                   width: 360,
// //                   padding: const EdgeInsets.all(24),
// //                   decoration: BoxDecoration(
// //                     color: isDark
// //                         ? Colors.black.withOpacity(0.4)
// //                         : Colors.white,
// //                     borderRadius: BorderRadius.circular(24),
// //                     border: Border.all(
// //                       color: isDark
// //                           ? Colors.white.withOpacity(0.2)
// //                           : Colors.black.withOpacity(0.2),
// //                     ),
// //                   ),
// //                   child: SingleChildScrollView(
// //                     child: Column(
// //                       children: [
// //                         CircleAvatar(
// //                           radius: 40,
// //                           backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
// //                           child: Icon(Icons.person, size: 40, color: theme.colorScheme.primary),
// //                         ),
// //                         const SizedBox(height: 16),
// //                         Text(
// //                           user?.email ?? '',
// //                           style: theme.textTheme.bodyLarge?.copyWith(
// //                             color: theme.colorScheme.onBackground.withOpacity(0.8),
// //                           ),
// //                         ),
// //                         const SizedBox(height: 24),
// //                         _buildTextField(_nameController, 'Name', Icons.person_outline),
// //                         const SizedBox(height: 16),
// //                         _buildTextField(
// //                           TextEditingController(text: user?.email ?? ''),
// //                           'Email',
// //                           Icons.email_outlined,
// //                           readOnly: true,
// //                         ),
// //                         const SizedBox(height: 16),
// //                         _buildTextField(
// //                           _currentPasswordController,
// //                           'Current Password',
// //                           Icons.lock_outline,
// //                           obscure: true,
// //                         ),
// //                         const SizedBox(height: 16),
// //                         _buildTextField(
// //                           _passwordController,
// //                           'New Password',
// //                           Icons.lock_reset_outlined,
// //                           obscure: true,
// //                         ),
// //                         const SizedBox(height: 24),
// //                         ElevatedButton(
// //                           onPressed: _isUpdating
// //                               ? null
// //                               : () async {
// //                             setState(() => _isUpdating = true);
// //                             await _updateProfile();
// //                             setState(() => _isUpdating = false);
// //                           },
// //                           style: ButtonStyle(
// //                             padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 18, horizontal: 24)),
// //                             shape: MaterialStateProperty.all(RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(16),
// //                             )),
// //                             elevation: MaterialStateProperty.all(6),
// //                             shadowColor: MaterialStateProperty.all(Colors.black45),
// //                             backgroundColor: MaterialStateProperty.resolveWith((states) {
// //                               if (states.contains(MaterialState.disabled)) {
// //                                 return Colors.grey.shade600;
// //                               }
// //                               return null; // We'll override it with Ink
// //                             }),
// //                           ),
// //                           child: Ink(
// //                             decoration: BoxDecoration(
// //                               gradient: const LinearGradient(
// //                                 colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
// //                                 begin: Alignment.topLeft,
// //                                 end: Alignment.bottomRight,
// //                               ),
// //                               borderRadius: BorderRadius.circular(16),
// //                             ),
// //                             child: Container(
// //                               alignment: Alignment.center,
// //                               constraints: const BoxConstraints(minWidth: double.infinity),
// //                               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
// //                               child: _isUpdating
// //                                   ? const SizedBox(
// //                                 height: 22,
// //                                 width: 22,
// //                                 child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
// //                               )
// //                                   : Row(
// //                                 mainAxisSize: MainAxisSize.min,
// //                                 mainAxisAlignment: MainAxisAlignment.center,
// //                                 children: const [
// //                                   Icon(Icons.save, color: Colors.white),
// //                                   SizedBox(width: 8),
// //                                   Text(
// //                                     'Update Profile',
// //                                     style: TextStyle(
// //                                       color: Colors.white,
// //                                       fontWeight: FontWeight.w600,
// //                                       fontSize: 16,
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                         // ElevatedButton.icon(
// //                         //   onPressed: _updateProfile,
// //                         //   // icon: const Icon(Icons.save),
// //                         //   label: const Text('Update Profile'),
// //                         //   style: ElevatedButton.styleFrom(
// //                         //     padding: const EdgeInsets.symmetric(vertical: 16),
// //                         //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //                         //     textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                         //   ),
// //                         // ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTextField(
// //       TextEditingController controller,
// //       String label,
// //       IconData icon, {
// //         bool readOnly = false,
// //         bool obscure = false,
// //       }) {
// //     return TextField(
// //       controller: controller,
// //       obscureText: obscure,
// //       readOnly: readOnly,
// //       decoration: InputDecoration(
// //         labelText: label,
// //         prefixIcon: Icon(icon),
// //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
// //         filled: true,
// //         fillColor: Theme.of(context).cardColor.withOpacity(0.05),
// //       ),
// //     );
// //   }
// // }
// //
// // class _BlobPainter extends CustomPainter {
// //   final double animationValue;
// //   final bool isDark;
// //
// //   _BlobPainter(this.animationValue, this.isDark);
// //
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     final paint = Paint();
// //
// //     final blob1Center = Offset(size.width * 0.3, size.height * 0.4);
// //     final blob1Radius = 180 + 20 * animationValue;
// //     paint.shader = RadialGradient(
// //       colors: [
// //         (isDark ? Colors.purpleAccent : Colors.deepPurple).withOpacity(0.5),
// //         Colors.transparent,
// //       ],
// //     ).createShader(Rect.fromCircle(center: blob1Center, radius: blob1Radius));
// //     canvas.drawCircle(blob1Center, blob1Radius, paint);
// //
// //     final blob2Center = Offset(size.width * 0.7, size.height * 0.7);
// //     final blob2Radius = 120 + 15 * animationValue;
// //     paint.shader = RadialGradient(
// //       colors: [
// //         (isDark ? Colors.cyanAccent : Colors.blueAccent).withOpacity(0.5),
// //         Colors.transparent,
// //       ],
// //     ).createShader(Rect.fromCircle(center: blob2Center, radius: blob2Radius));
// //     canvas.drawCircle(blob2Center, blob2Radius, paint);
// //   }
// //
// //   @override
// //   bool shouldRepaint(covariant _BlobPainter oldDelegate) {
// //     return oldDelegate.animationValue != animationValue || oldDelegate.isDark != isDark;
// //   }
// // }
// //
// //
// //
//
//
// import 'dart:math';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../features/Avatar_provider.dart';
//
// import '../model/UserModel.dart';
//
// class ProfileScreen extends ConsumerStatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _currentPasswordController = TextEditingController();
//
//   bool _isUpdating = false;
//
//   late final AnimationController _animationController;
//
//   final List<String> _presetAvatars = [
//     'https://i.pravatar.cc/150?img=1',
//     'https://i.pravatar.cc/150?img=2',
//     'https://i.pravatar.cc/150?img=3',
//     'https://i.pravatar.cc/150?img=4',
//     'https://i.pravatar.cc/150?img=5',
//   ];
//
//   String? _selectedAvatar;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserProfile();
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 6),
//     )..repeat(reverse: true);
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _passwordController.dispose();
//     _currentPasswordController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _loadUserProfile() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//       if (userDoc.exists) {
//         final userModel = UserModel.fromMap(userDoc.data()!);
//         _nameController.text = userModel.name ?? '';
//         _selectedAvatar = userModel.avatarUrl;
//         ref.read(avatarProvider.notifier).state = _selectedAvatar;
//         setState(() {}); // Refresh avatar UI
//       }
//     }
//   }
//
//   Future<void> _updateProfile() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final name = _nameController.text.trim();
//       final password = _passwordController.text.trim();
//       final currentPassword = _currentPasswordController.text.trim();
//
//       try {
//         if (password.isNotEmpty) {
//           if (currentPassword.isEmpty) {
//             _showSnackBar('Please enter your current password to update it');
//             return;
//           }
//
//           final cred = EmailAuthProvider.credential(
//             email: user.email!,
//             password: currentPassword,
//           );
//           await user.reauthenticateWithCredential(cred);
//           await user.updatePassword(password);
//         }
//
//         await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
//           'name': name,
//           'avatarUrl': _selectedAvatar, // ✅ Save avatar URL
//         });
//
//         ref.read(avatarProvider.notifier).state = _selectedAvatar; // ✅ Update provider
//
//         _showSnackBar('Profile updated successfully');
//       } catch (e) {
//         _showSnackBar('Error: ${e.toString()}');
//       }
//     } else {
//       _showSnackBar('No user found');
//     }
//   }
//
//   void _showSnackBar(String message) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final snackBar = SnackBar(
//       behavior: SnackBarBehavior.floating,
//       margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//       backgroundColor: isDark
//           ? Colors.black.withOpacity(0.85)
//           : Colors.white.withOpacity(0.9),
//       elevation: 10,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: BorderSide(
//           color: isDark ? Colors.cyanAccent : Colors.indigo,
//           width: 1.5,
//         ),
//       ),
//       content: Text(
//         message,
//         style: TextStyle(
//           color: isDark ? Colors.cyanAccent.shade100 : Colors.indigo.shade900,
//           fontWeight: FontWeight.w600,
//           fontSize: 16,
//         ),
//       ),
//     );
//
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           AnimatedBuilder(
//             animation: _animationController,
//             builder: (context, _) {
//               final progress = _animationController.value;
//               return CustomPaint(
//                 painter: _BlobPainter(progress, isDark),
//               );
//             },
//           ),
//           Center(
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(24),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
//                 child: Container(
//                   width: 360,
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: isDark
//                         ? Colors.black.withOpacity(0.4)
//                         : Colors.white,
//                     borderRadius: BorderRadius.circular(24),
//                     border: Border.all(
//                       color: isDark
//                           ? Colors.white.withOpacity(0.2)
//                           : Colors.black.withOpacity(0.2),
//                     ),
//                   ),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 40,
//                           backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
//                           backgroundImage: _selectedAvatar != null ? NetworkImage(_selectedAvatar!) : null,
//                           child: _selectedAvatar == null
//                               ? Icon(Icons.person, size: 40, color: theme.colorScheme.primary)
//                               : null,
//                         ),
//                         const SizedBox(height: 12),
//                         SizedBox(
//                           height: 80,
//                           child: ListView.separated(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: _presetAvatars.length,
//                             separatorBuilder: (_, __) => const SizedBox(width: 12),
//                             itemBuilder: (context, index) {
//                               final avatarUrl = _presetAvatars[index];
//                               final isSelected = avatarUrl == _selectedAvatar;
//
//                               return GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     _selectedAvatar = avatarUrl;
//                                   });
//                                   ref.read(avatarProvider.notifier).updateAvatar(avatarUrl);
//
//                                   // ref.read(avatarProvider.notifier).state = avatarUrl; // ✅ update globally
//                                 },
//                                 child: CircleAvatar(
//                                   radius: isSelected ? 30 : 28,
//                                   backgroundColor: isSelected
//                                       ? theme.colorScheme.primary
//                                       : Colors.grey.shade300,
//                                   child: CircleAvatar(
//                                     radius: 26,
//                                     backgroundImage: NetworkImage(avatarUrl),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           user?.email ?? '',
//                           style: theme.textTheme.bodyLarge?.copyWith(
//                             color: theme.colorScheme.onBackground.withOpacity(0.8),
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                         _buildTextField(_nameController, 'Name', Icons.person_outline),
//                         const SizedBox(height: 16),
//                         _buildTextField(TextEditingController(text: user?.email ?? ''), 'Email', Icons.email_outlined, readOnly: true),
//                         const SizedBox(height: 16),
//                         _buildTextField(_currentPasswordController, 'Current Password', Icons.lock_outline, obscure: true),
//                         const SizedBox(height: 16),
//                         _buildTextField(_passwordController, 'New Password', Icons.lock_reset_outlined, obscure: true),
//                         const SizedBox(height: 24),
//                         ElevatedButton(
//                           onPressed: _isUpdating
//                               ? null
//                               : () async {
//                             setState(() => _isUpdating = true);
//                             await _updateProfile();
//                             setState(() => _isUpdating = false);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                             padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
//                           ),
//                           child: _isUpdating
//                               ? const SizedBox(
//                             height: 22,
//                             width: 22,
//                             child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
//                           )
//                               : Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: const [
//                               Icon(Icons.save, color: Colors.white),
//                               SizedBox(width: 8),
//                               Text("Update Profile", style: TextStyle(color: Colors.white)),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTextField(TextEditingController controller, String label, IconData icon,
//       {bool readOnly = false, bool obscure = false}) {
//     return TextField(
//       controller: controller,
//       obscureText: obscure,
//       readOnly: readOnly,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         filled: true,
//         fillColor: Theme.of(context).cardColor.withOpacity(0.05),
//       ),
//     );
//   }
// }
//
// class _BlobPainter extends CustomPainter {
//   final double animationValue;
//   final bool isDark;
//
//   _BlobPainter(this.animationValue, this.isDark);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint();
//
//     final blob1Center = Offset(size.width * 0.3, size.height * 0.4);
//     final blob1Radius = 180 + 20 * animationValue;
//     paint.shader = RadialGradient(
//       colors: [
//         (isDark ? Colors.purpleAccent : Colors.deepPurple).withOpacity(0.5),
//         Colors.transparent,
//       ],
//     ).createShader(Rect.fromCircle(center: blob1Center, radius: blob1Radius));
//     canvas.drawCircle(blob1Center, blob1Radius, paint);
//
//     final blob2Center = Offset(size.width * 0.7, size.height * 0.7);
//     final blob2Radius = 120 + 15 * animationValue;
//     paint.shader = RadialGradient(
//       colors: [
//         (isDark ? Colors.cyanAccent : Colors.blueAccent).withOpacity(0.5),
//         Colors.transparent,
//       ],
//     ).createShader(Rect.fromCircle(center: blob2Center, radius: blob2Radius));
//     canvas.drawCircle(blob2Center, blob2Radius, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant _BlobPainter oldDelegate) {
//     return oldDelegate.animationValue != animationValue || oldDelegate.isDark != isDark;
//   }
// }
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/Avatar_provider.dart';
import '../model/UserModel.dart' hide UserModel;

// class ProfileScreen extends ConsumerStatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _currentPasswordController = TextEditingController();
//
//   bool _isUpdating = false;
//   late final AnimationController _animationController;
//
//   final List<String> _presetAvatars = [
//     'https://i.pravatar.cc/150?img=1',
//     'https://i.pravatar.cc/150?img=2',
//     'https://i.pravatar.cc/150?img=3',
//     'https://i.pravatar.cc/150?img=4',
//     'https://i.pravatar.cc/150?img=5',
//   ];
//
//   String? _selectedAvatar;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserProfile();
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 6),
//     )..repeat(reverse: true);
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _passwordController.dispose();
//     _currentPasswordController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _loadUserProfile() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//       if (userDoc.exists) {
//         final userModel = UserModel.fromMap(userDoc.data()!);
//         _nameController.text = userModel.name ?? '';
//         _selectedAvatar = userModel.avatarUrl;
//
//         // Update the avatarProvider with the current user's avatar only
//         ref.read(avatarProvider.notifier).updateAvatar(_selectedAvatar ?? '');
//
//         setState(() {}); // Refresh UI
//       }
//     }
//   }
//
//   Future<void> _updateProfile() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final name = _nameController.text.trim();
//       final password = _passwordController.text.trim();
//       final currentPassword = _currentPasswordController.text.trim();
//
//       try {
//         if (password.isNotEmpty) {
//           if (currentPassword.isEmpty) {
//             _showSnackBar('Please enter your current password to update it');
//             return;
//           }
//
//           final cred = EmailAuthProvider.credential(
//             email: user.email!,
//             password: currentPassword,
//           );
//           await user.reauthenticateWithCredential(cred);
//           await user.updatePassword(password);
//         }
//
//         await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
//           'name': name,
//           'avatarUrl': _selectedAvatar, // Save avatar URL specific to this user
//         });
//
//         // Update provider with this user's avatar
//         ref.read(avatarProvider.notifier).updateAvatar(_selectedAvatar ?? '');
//
//         _showSnackBar('Profile updated successfully');
//       } catch (e) {
//         _showSnackBar('Error: ${e.toString()}');
//       }
//     } else {
//       _showSnackBar('No user found');
//     }
//   }
//
//   void _showSnackBar(String message) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final snackBar = SnackBar(
//       behavior: SnackBarBehavior.floating,
//       margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//       backgroundColor: isDark
//           ? Colors.black.withOpacity(0.85)
//           : Colors.white.withOpacity(0.9),
//       elevation: 10,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: BorderSide(
//           color: isDark ? Colors.cyanAccent : Colors.indigo,
//           width: 1.5,
//         ),
//       ),
//       content: Text(
//         message,
//         style: TextStyle(
//           color: isDark ? Colors.cyanAccent.shade100 : Colors.indigo.shade900,
//           fontWeight: FontWeight.w600,
//           fontSize: 16,
//         ),
//       ),
//     );
//
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           AnimatedBuilder(
//             animation: _animationController,
//             builder: (context, _) {
//               final progress = _animationController.value;
//               return CustomPaint(
//                 painter: _BlobPainter(progress, isDark),
//               );
//             },
//           ),
//           Center(
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(24),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
//                 child: Container(
//                   width: 360,
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: isDark
//                         ? Colors.black.withOpacity(0.4)
//                         : Colors.white,
//                     borderRadius: BorderRadius.circular(24),
//                     border: Border.all(
//                       color: isDark
//                           ? Colors.white.withOpacity(0.2)
//                           : Colors.black.withOpacity(0.2),
//                     ),
//                   ),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 40,
//                           backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
//                           backgroundImage: _selectedAvatar != null ? NetworkImage(_selectedAvatar!) : null,
//                           child: _selectedAvatar == null
//                               ? Icon(Icons.person, size: 40, color: theme.colorScheme.primary)
//                               : null,
//                         ),
//                         const SizedBox(height: 12),
//                         SizedBox(
//                           height: 80,
//                           child: ListView.separated(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: _presetAvatars.length,
//                             separatorBuilder: (_, __) => const SizedBox(width: 12),
//                             itemBuilder: (context, index) {
//                               final avatarUrl = _presetAvatars[index];
//                               final isSelected = avatarUrl == _selectedAvatar;
//
//                               return GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     _selectedAvatar = avatarUrl;
//                                   });
//                                   ref.read(avatarProvider.notifier).updateAvatar(avatarUrl);
//                                 },
//                                 child: CircleAvatar(
//                                   radius: isSelected ? 30 : 28,
//                                   backgroundColor: isSelected
//                                       ? theme.colorScheme.primary
//                                       : Colors.grey.shade300,
//                                   child: CircleAvatar(
//                                     radius: 26,
//                                     backgroundImage: NetworkImage(avatarUrl),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           user?.email ?? '',
//                           style: theme.textTheme.bodyLarge?.copyWith(
//                             color: theme.colorScheme.onBackground.withOpacity(0.8),
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                         _buildTextField(_nameController, 'Name', Icons.person_outline),
//                         const SizedBox(height: 16),
//                         _buildTextField(
//                           TextEditingController(text: user?.email ?? ''),
//                           'Email',
//                           Icons.email_outlined,
//                           readOnly: true,
//                         ),
//                         const SizedBox(height: 16),
//                         _buildTextField(_currentPasswordController, 'Current Password', Icons.lock_outline, obscure: true),
//                         const SizedBox(height: 16),
//                         _buildTextField(_passwordController, 'New Password', Icons.lock_reset_outlined, obscure: true),
//                         const SizedBox(height: 24),
//                         ElevatedButton(
//                           onPressed: _isUpdating
//                               ? null
//                               : () async {
//                             setState(() => _isUpdating = true);
//                             await _updateProfile();
//                             setState(() => _isUpdating = false);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                             padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
//                           ),
//                           child: _isUpdating
//                               ? const SizedBox(
//                             height: 22,
//                             width: 22,
//                             child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
//                           )
//                               : Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: const [
//                               Icon(Icons.save, color: Colors.white),
//                               SizedBox(width: 8),
//                               Text("Update Profile", style: TextStyle(color: Colors.white)),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTextField(TextEditingController controller, String label, IconData icon,
//       {bool readOnly = false, bool obscure = false}) {
//     return TextField(
//       controller: controller,
//       obscureText: obscure,
//       readOnly: readOnly,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         filled: true,
//         fillColor: Theme.of(context).cardColor.withOpacity(0.05),
//       ),
//     );
//   }
// }
//
// class _BlobPainter extends CustomPainter {
//   final double animationValue;
//   final bool isDark;
//
//   _BlobPainter(this.animationValue, this.isDark);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint();
//
//     final blob1Center = Offset(size.width * 0.3, size.height * 0.4);
//     final blob1Radius = 180 + 20 * animationValue;
//     paint.shader = RadialGradient(
//       colors: [
//         (isDark ? Colors.purpleAccent : Colors.deepPurple).withOpacity(0.5),
//         Colors.transparent,
//       ],
//     ).createShader(Rect.fromCircle(center: blob1Center, radius: blob1Radius));
//     canvas.drawCircle(blob1Center, blob1Radius, paint);
//
//     final blob2Center = Offset(size.width * 0.7, size.height * 0.7);
//     final blob2Radius = 120 + 15 * animationValue;
//     paint.shader = RadialGradient(
//       colors: [
//         (isDark ? Colors.cyanAccent : Colors.blueAccent).withOpacity(0.5),
//         Colors.transparent,
//       ],
//     ).createShader(Rect.fromCircle(center: blob2Center, radius: blob2Radius));
//     canvas.drawCircle(blob2Center, blob2Radius, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant _BlobPainter oldDelegate) {
//     return oldDelegate.animationValue != animationValue || oldDelegate.isDark != isDark;
//   }
// }

import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/Avatar_provider.dart';
import 'package:cardo/model/UserModel.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();

  bool _isUpdating = false;
  late final AnimationController _animationController;

  final List<String> _presetAvatars = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSO36HQLxnHwrjPBPzTDnwViZdr24GaFEPISQ&s',
    'https://i.pinimg.com/474x/4b/be/27/4bbe27b2b942334bf9e7a9b8211d1203.jpg',
    'https://avatarfiles.alphacoders.com/844/84461.jpg',
    'https://i.pinimg.com/736x/8a/d9/f8/8ad9f8400a8bf8221aee075cd38bffa1.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1any1Cjr1ko9PdEGazxWNqVK8ZifuyUtmWg&s',
    'https://i.pinimg.com/564x/de/a3/25/dea325f568138dc0909fe0f5410e8e2b.jpg',
    'https://preview.redd.it/how-strong-is-boa-hancock-v0-cg9hz67ag4me1.jpeg?auto=webp&s=9fc974bbc3c6ba71f0a12041cf3f78b8d5751985',
    'https://i.pinimg.com/736x/47/8c/fc/478cfcb862f58425560bd1870f83ac43.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1x6zXQjD64fNKEBvvvseZMH0eqy3hYBZTmA&s',
  ];

  String? _selectedAvatar;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _currentPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final userModel = UserModel.fromMap(userDoc.data()!);
        _nameController.text = userModel.name ?? '';
        _selectedAvatar = userModel.avatarUrl;

        // Update the avatarProvider with the current user's avatar only
        ref.read(avatarProvider.notifier).updateAvatar(_selectedAvatar ?? '');

        setState(() {}); // Refresh UI
      }
    }
  }

  Future<void> _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final name = _nameController.text.trim();
      final password = _passwordController.text.trim();
      final currentPassword = _currentPasswordController.text.trim();

      try {
        if (password.isNotEmpty) {
          if (currentPassword.isEmpty) {
            _showSnackBar('Please enter your current password to update it');
            return;
          }

          final cred = EmailAuthProvider.credential(
            email: user.email!,
            password: currentPassword,
          );
          await user.reauthenticateWithCredential(cred);
          await user.updatePassword(password);
        }

        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'name': name,
          'avatarUrl': _selectedAvatar, // Save avatar URL specific to this user
        });

        // Update provider with this user's avatar
        ref.read(avatarProvider.notifier).updateAvatar(_selectedAvatar ?? '');

        _showSnackBar('Profile updated successfully');
      } catch (e) {
        _showSnackBar('Error: ${e.toString()}');
      }
    } else {
      _showSnackBar('No user found');
    }
  }

  void _showSnackBar(String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      backgroundColor: isDark
          ? Colors.black.withOpacity(0.85)
          : Colors.white.withOpacity(0.9),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.cyanAccent : Colors.indigo,
          width: 1.5,
        ),
      ),
      content: Text(
        message,
        style: TextStyle(
          color: isDark ? Colors.cyanAccent.shade100 : Colors.indigo.shade900,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, _) {
              final progress = _animationController.value;
              return CustomPaint(
                painter: _BlobPainter(progress, isDark),
              );
            },
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  width: 360,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withOpacity(0.4)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.2),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                          backgroundImage: _selectedAvatar != null ? NetworkImage(_selectedAvatar!) : null,
                          child: _selectedAvatar == null
                              ? Icon(Icons.person, size: 40, color: theme.colorScheme.primary)
                              : null,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 80,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _presetAvatars.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final avatarUrl = _presetAvatars[index];
                              final isSelected = avatarUrl == _selectedAvatar;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedAvatar = avatarUrl;
                                  });
                                  ref.read(avatarProvider.notifier).updateAvatar(avatarUrl);
                                },
                                child: CircleAvatar(
                                  radius: isSelected ? 30 : 28,
                                  backgroundColor: isSelected
                                      ? theme.colorScheme.primary
                                      : Colors.grey.shade300,
                                  child: CircleAvatar(
                                    radius: 26,
                                    backgroundImage: NetworkImage(avatarUrl),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user?.email ?? '',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onBackground.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildTextField(_nameController, 'Name', Icons.person_outline),
                        const SizedBox(height: 16),
                        _buildTextField(
                          TextEditingController(text: user?.email ?? ''),
                          'Email',
                          Icons.email_outlined,
                          readOnly: true,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(_currentPasswordController, 'Current Password', Icons.lock_outline, obscure: true),
                        const SizedBox(height: 16),
                        _buildTextField(_passwordController, 'New Password', Icons.lock_reset_outlined, obscure: true),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isUpdating
                              ? null
                              : () async {
                            setState(() => _isUpdating = true);
                            await _updateProfile();
                            setState(() => _isUpdating = false);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                          ),
                          child: _isUpdating
                              ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                              : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.save, color: Colors.white),
                              SizedBox(width: 8),
                              Text("Update Profile", style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {bool readOnly = false, bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).cardColor.withOpacity(0.05),
      ),
    );
  }
}

class _BlobPainter extends CustomPainter {
  final double animationValue;
  final bool isDark;

  _BlobPainter(this.animationValue, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    final blob1Center = Offset(size.width * 0.3, size.height * 0.4);
    final blob1Radius = 180 + 20 * animationValue;
    paint.shader = RadialGradient(
      colors: [
        (isDark ? Colors.purpleAccent : Colors.deepPurple).withOpacity(0.5),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: blob1Center, radius: blob1Radius));
    canvas.drawCircle(blob1Center, blob1Radius, paint);

    final blob2Center = Offset(size.width * 0.7, size.height * 0.7);
    final blob2Radius = 120 + 15 * animationValue;
    paint.shader = RadialGradient(
      colors: [
        (isDark ? Colors.cyanAccent : Colors.blueAccent).withOpacity(0.5),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: blob2Center, radius: blob2Radius));
    canvas.drawCircle(blob2Center, blob2Radius, paint);
  }

  @override
  bool shouldRepaint(covariant _BlobPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue || oldDelegate.isDark != isDark;
  }
}
