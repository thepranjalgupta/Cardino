
// import 'dart:ui';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lottie/lottie.dart';
// import 'package:animate_do/animate_do.dart';
// import '../features/authRepositoryProvider.dart';
// import 'AuthGate.dart';
//
// class LoginPage extends ConsumerStatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   ConsumerState<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends ConsumerState<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _email = TextEditingController();
//   final _password = TextEditingController();
//   bool _isLogin = true;
//   bool _playButtonAnimation = false; // ✅ NEW flag
//
//   @override
//   void dispose() {
//     _email.dispose();
//     _password.dispose();
//     super.dispose();
//   }
//
//   Future<void> _submit(BuildContext context) async {
//     if (!_formKey.currentState!.validate()) return;
//
//     final email = _email.text.trim();
//     final pass = _password.text;
//
//     if (_isLogin) {
//       await ref.read(authControllerProvider.notifier).signIn(email, pass);
//     } else {
//       await ref.read(authControllerProvider.notifier).signUp(email, pass);
//
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null && !user.emailVerified) {
//         await user.sendEmailVerification();
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("Verification email sent. Please verify before login."),
//             ),
//           );
//         }
//         return;
//       }
//     }
//
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null && (_isLogin || user.emailVerified) && context.mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const AuthGate()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(authControllerProvider);
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return Scaffold(
//       resizeToAvoidBottomInset: true, // ✅ fixes overflow
//       body: Stack(
//         children: [
//           /// 🌌 Animated Gradient Background
//           AnimatedContainer(
//             duration: const Duration(seconds: 3),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: isDark
//                     ? [const Color(0xFF0f172a), const Color(0xFF1e293b), Colors.black]
//                     : [const Color(0xFFe0e7ff), const Color(0xFFfdf4ff), Colors.white],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//
//           /// 🌟 Floating Neon Orbs
//           Positioned(
//             top: 80,
//             left: -40,
//             child: _glowingOrb(120, Colors.purpleAccent.withOpacity(0.3)),
//           ),
//           Positioned(
//             bottom: 100,
//             right: -30,
//             child: _glowingOrb(180, Colors.cyanAccent.withOpacity(0.25)),
//           ),
//
//           /// 🔮 Glassmorphic Card
//           Center(
//             child: FadeInUp(
//               duration: const Duration(milliseconds: 800),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(30),
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//                   child: Container(
//                     width: 380,
//                     padding: const EdgeInsets.all(28),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(30),
//                       border: Border.all(
//                         color: isDark
//                             ? Colors.cyanAccent.withOpacity(0.4)
//                             : Colors.purpleAccent.withOpacity(0.4),
//                       ),
//                       gradient: LinearGradient(
//                         colors: [
//                           isDark ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.5),
//                           isDark ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.3),
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//
//                     /// ✅ FIX: Scrollable Form
//                     child: SingleChildScrollView(
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             /// 🪐 Lottie Animation (Login / Signup switch)
//                             SizedBox(
//                               height: 140,
//                               child: Lottie.asset(
//                                 _isLogin
//                                     ? 'assets/lottie/login.json'
//                                     : 'assets/lottie/createacca.json',
//                                 repeat: true,
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//
//                             Text(
//                               _isLogin ? "Welcome Back" : "Create Account",
//                               style: TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 color: isDark ? Colors.white : Colors.black87,
//                               ),
//                             ),
//                             const SizedBox(height: 24),
//
//                             /// ✉️ Email
//                             SlideInLeft(
//                               child: TextFormField(
//                                 controller: _email,
//                                 style: TextStyle(color: isDark ? Colors.white : Colors.black),
//                                 decoration: _inputDecoration("Email", Icons.email_outlined, isDark),
//                                 validator: (v) =>
//                                 v != null && v.contains('@') ? null : 'Enter a valid email',
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//
//                             /// 🔒 Password
//                             SlideInRight(
//                               child: TextFormField(
//                                 controller: _password,
//                                 style: TextStyle(color: isDark ? Colors.white : Colors.black),
//                                 decoration: _inputDecoration("Password", Icons.lock_outline, isDark),
//                                 obscureText: true,
//                                 validator: (v) =>
//                                 v != null && v.length >= 6 ? null : 'Min 6 characters',
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//
//                             if (state.error != null)
//                               Text(
//                                 state.error!,
//                                 style: const TextStyle(color: Colors.redAccent),
//                               ),
//
//                             /// 🚀 Futuristic Button
//                             const SizedBox(height: 12),
//                             SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   padding: const EdgeInsets.symmetric(vertical: 14),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   backgroundColor: Colors.transparent,
//                                   shadowColor: Colors.transparent,
//                                 ),
//                                 onPressed: state.loading
//                                     ? null
//                                     : () {
//                                   setState(() {
//                                     _playButtonAnimation = true; // trigger button anim
//                                   });
//                                   _submit(context).then((_) {
//                                     // Reset after a short delay
//                                     Future.delayed(const Duration(seconds: 2), () {
//                                       if (mounted) {
//                                         setState(() => _playButtonAnimation = false);
//                                       }
//                                     });
//                                   });
//                                 },
//                                 child: state.loading
//                                     ? SizedBox(
//                                   height: 50,
//                                   child: Lottie.asset('assets/lottie/loading.json'),
//                                 )
//                                     : Ink(
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: [
//                                         isDark ? Colors.cyanAccent : Colors.purpleAccent,
//                                         isDark ? Colors.blueAccent : Colors.deepPurple,
//                                       ],
//                                     ),
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     height: 60, // ✅ fix button height
//                                     child: _playButtonAnimation
//                                         ? Transform.scale(
//                                       scale: 1.4, // ✅ scale up to remove lottie padding
//                                       child: Lottie.asset(
//                                         _isLogin
//                                             ? 'assets/lottie/loading.json'
//                                             : 'assets/lottie/sentmail.json',
//                                         height: 60,
//                                         fit: BoxFit.contain,
//                                         repeat: false,
//                                       ),
//                                     )
//                                         : Text(
//                                       _isLogin ? "Login" : "Sign Up",
//                                       style: const TextStyle(
//                                         fontSize: 18, // ✅ slightly larger to match button height
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   )
//
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//
//                             GestureDetector(
//                               onTap: () => setState(() => _isLogin = !_isLogin),
//                               child: Text(
//                                 _isLogin
//                                     ? "Don't have an account? Sign up"
//                                     : "Already have an account? Login",
//                                 style: TextStyle(
//                                   color: isDark ? Colors.cyanAccent : Colors.deepPurple,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
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
//   /// 🔵 Neon glowing orb
//   Widget _glowingOrb(double size, Color color) {
//     return Container(
//       height: size,
//       width: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: color,
//         boxShadow: [BoxShadow(color: color, blurRadius: 80, spreadRadius: 30)],
//       ),
//     );
//   }
//
//   /// 📝 Futuristic Input Decoration
//   InputDecoration _inputDecoration(String label, IconData icon, bool isDark) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
//       prefixIcon: Icon(icon, color: isDark ? Colors.cyanAccent : Colors.deepPurple),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(color: isDark ? Colors.cyanAccent : Colors.purpleAccent),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(
//           color: isDark ? Colors.cyanAccent : Colors.deepPurple,
//           width: 2,
//         ),
//       ),
//       filled: true,
//       fillColor: isDark ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.7),
//     );
//   }
// }
//
// import 'dart:ui';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lottie/lottie.dart';
// import 'package:animate_do/animate_do.dart';
// import '../features/authRepositoryProvider.dart';
// import 'AuthGate.dart';
//
// class LoginPage extends ConsumerStatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   ConsumerState<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends ConsumerState<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _email = TextEditingController();
//   final _password = TextEditingController();
//   bool _isLogin = true;
//   bool _playButtonAnimation = false; // ✅ NEW flag
//
//   @override
//   void dispose() {
//     _email.dispose();
//     _password.dispose();
//     super.dispose();
//   }
//
//   Future<void> _submit(BuildContext context) async {
//     if (!_formKey.currentState!.validate()) return;
//
//     final email = _email.text.trim();
//     final pass = _password.text;
//
//     if (_isLogin) {
//       await ref.read(authControllerProvider.notifier).signIn(email, pass);
//     } else {
//       await ref.read(authControllerProvider.notifier).signUp(email, pass);
//
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null && !user.emailVerified) {
//         await user.sendEmailVerification();
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text(
//                 "Verification email sent. Please verify before login.",
//               ),
//             ),
//           );
//         }
//         return;
//       }
//     }
//
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null && (_isLogin || user.emailVerified) && context.mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const AuthGate()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(authControllerProvider);
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return Scaffold(
//       resizeToAvoidBottomInset: true, // ✅ fixes overflow
//       body: Stack(
//         children: [
//           /// 🌌 Animated Gradient Background
//           AnimatedContainer(
//             duration: const Duration(seconds: 3),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: isDark
//                     ? [
//                         const Color(0xFF0f172a),
//                         const Color(0xFF1e293b),
//                         Colors.black,
//                       ]
//                     : [
//                         const Color(0xFFe0e7ff),
//                         const Color(0xFFfdf4ff),
//                         Colors.white,
//                       ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//
//           /// 🌟 Floating Neon Orbs
//           Positioned(
//             top: 80,
//             left: -40,
//             child: _glowingOrb(120, Colors.purpleAccent.withOpacity(0.3)),
//           ),
//           Positioned(
//             bottom: 100,
//             right: -30,
//             child: _glowingOrb(180, Colors.cyanAccent.withOpacity(0.25)),
//           ),
//
//           /// 🔮 Glassmorphic Card
//           Center(
//             child: FadeInUp(
//               duration: const Duration(milliseconds: 800),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(30),
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//                   child: Container(
//                     width: 380,
//                     padding: const EdgeInsets.all(28),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(30),
//                       border: Border.all(
//                         color: isDark
//                             ? Colors.cyanAccent.withOpacity(0.4)
//                             : Colors.purpleAccent.withOpacity(0.4),
//                       ),
//                       gradient: LinearGradient(
//                         colors: [
//                           isDark
//                               ? Colors.black.withOpacity(0.5)
//                               : Colors.white.withOpacity(0.5),
//                           isDark
//                               ? Colors.black.withOpacity(0.2)
//                               : Colors.white.withOpacity(0.3),
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//
//                     /// ✅ FIX: Scrollable Form
//                     child: SingleChildScrollView(
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             /// 🪐 Lottie Animation (Login / Signup switch)
//                             SizedBox(
//                               height: 140,
//                               child: Lottie.asset(
//                                 _isLogin
//                                     ? 'assets/lottie/login.json'
//                                     : 'assets/lottie/createacca.json',
//                                 repeat: true,
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//
//                             Text(
//                               _isLogin ? "Welcome Back" : "Create Account",
//                               style: TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 color: isDark ? Colors.white : Colors.black87,
//                               ),
//                             ),
//                             const SizedBox(height: 24),
//
//                             /// ✉️ Email
//                             SlideInLeft(
//                               child: TextFormField(
//                                 controller: _email,
//                                 style: TextStyle(
//                                   color: isDark ? Colors.white : Colors.black,
//                                 ),
//                                 decoration: _inputDecoration(
//                                   "Email",
//                                   Icons.email_outlined,
//                                   isDark,
//                                 ),
//                                 validator: (v) => v != null && v.contains('@')
//                                     ? null
//                                     : 'Enter a valid email',
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//
//                             /// 🔒 Password
//                             SlideInRight(
//                               child: TextFormField(
//                                 controller: _password,
//                                 style: TextStyle(
//                                   color: isDark ? Colors.white : Colors.black,
//                                 ),
//                                 decoration: _inputDecoration(
//                                   "Password",
//                                   Icons.lock_outline,
//                                   isDark,
//                                 ),
//                                 obscureText: true,
//                                 validator: (v) => v != null && v.length >= 6
//                                     ? null
//                                     : 'Min 6 characters',
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//
//                             if (state.error != null)
//                               Text(
//                                 state.error!,
//                                 style: const TextStyle(color: Colors.redAccent),
//                               ),
//
//                             /// 🚀 Futuristic Button
//                             const SizedBox(height: 12),
//                             SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 14,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   backgroundColor: Colors.transparent,
//                                   shadowColor: Colors.transparent,
//                                 ),
//                                 onPressed: state.loading
//                                     ? null
//                                     : () {
//                                         setState(() {
//                                           _playButtonAnimation =
//                                               true; // trigger button anim
//                                         });
//                                         _submit(context).then((_) {
//                                           // Reset after a short delay
//                                           Future.delayed(
//                                             const Duration(seconds: 2),
//                                             () {
//                                               if (mounted) {
//                                                 setState(
//                                                   () => _playButtonAnimation =
//                                                       false,
//                                                 );
//                                               }
//                                             },
//                                           );
//                                         });
//                                       },
//                                 child: state.loading
//                                     ? SizedBox(
//                                         height: 50,
//                                         child: Lottie.asset(
//                                           'assets/lottie/loading.json',
//                                         ),
//                                       )
//                                     : Ink(
//                                         decoration: BoxDecoration(
//                                           gradient: LinearGradient(
//                                             colors: [
//                                               isDark
//                                                   ? Colors.cyanAccent
//                                                   : Colors.purpleAccent,
//                                               isDark
//                                                   ? Colors.blueAccent
//                                                   : Colors.deepPurple,
//                                             ],
//                                           ),
//                                           borderRadius: BorderRadius.circular(
//                                             16,
//                                           ),
//                                         ),
//                                         child: Container(
//                                           alignment: Alignment.center,
//                                           height: 60, // ✅ fix button height
//                                           child: _playButtonAnimation
//                                               ? Transform.scale(
//                                                   scale: 1.4,
//                                                   // ✅ scale up to remove lottie padding
//                                                   child: Lottie.asset(
//                                                     _isLogin
//                                                         ? 'assets/lottie/loading.json'
//                                                         : 'assets/lottie/sentmail.json',
//                                                     height: 60,
//                                                     fit: BoxFit.contain,
//                                                     repeat: false,
//                                                   ),
//                                                 )
//                                               : Text(
//                                                   _isLogin
//                                                       ? "Login"
//                                                       : "Sign Up",
//                                                   style: const TextStyle(
//                                                     fontSize: 18,
//                                                     // ✅ slightly larger to match button height
//                                                     fontWeight: FontWeight.bold,
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                         ),
//                                       ),
//                               ),
//                             ),
//
//                             /// ✅ Resend Verification Button (Signup only)
//                             /// ✅ Resend Verification Button (Signup only)
//                             if (!_isLogin) ...[
//                               const SizedBox(height: 16),
//                               ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   padding: EdgeInsets.zero,
//                                   // remove default padding to let gradient show
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   backgroundColor: Colors.transparent,
//                                   // transparent for gradient
//                                   shadowColor: Colors.transparent,
//                                   elevation: 6,
//                                 ),
//                                 onPressed: () {
//                                   final user =
//                                       FirebaseAuth.instance.currentUser;
//
//                                   // Fire and forget (don’t await, so navigation is instant 🚀)
//                                   if (user != null && !user.emailVerified) {
//                                     user.sendEmailVerification();
//                                   }
//
//                                   // 🚀 Immediately navigate to AuthGate
//                                   Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => const AuthGate(),
//                                     ),
//                                   );
//                                 },
//                                 child: Ink(
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: [
//                                         const Color(0xFF6EE7F9),
//                                         // main brand purple
//                                         const Color(0xFF6D28D9),
//                                         // darker purple for depth
//                                       ],
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomRight,
//                                     ),
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 14,
//                                     ),
//                                     child: const Text(
//                                       "Resend Email",
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                         letterSpacing: 0.8,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               // ElevatedButton(
//                               //   style: ElevatedButton.styleFrom(
//                               //     padding: const EdgeInsets.symmetric(vertical: 14),
//                               //     shape: RoundedRectangleBorder(
//                               //       borderRadius: BorderRadius.circular(16),
//                               //     ),
//                               //     backgroundColor: isDark ? Color(0xFF8B5CF6) : Color(0xFF8B5CF6),
//                               //   ),
//                               //   onPressed: () {
//                               //     final user = FirebaseAuth.instance.currentUser;
//                               //
//                               //     // Fire and forget (don’t await, so navigation is instant 🚀)
//                               //     if (user != null && !user.emailVerified) {
//                               //       user.sendEmailVerification();
//                               //     }
//                               //
//                               //     // 🚀 Immediately navigate to AuthGate
//                               //     Navigator.pushReplacement(
//                               //       context,
//                               //       MaterialPageRoute(builder: (_) => const AuthGate()),
//                               //     );
//                               //   },
//                               //   child: Padding(
//                               //     padding: const EdgeInsets.all(12.0),
//                               //     child: const Text(
//                               //       "Resend Email",
//                               //       style: TextStyle(
//                               //         fontSize: 16,
//                               //         fontWeight: FontWeight.bold,
//                               //         color: Colors.white,
//                               //       ),
//                               //     ),
//                               //   ),
//                               // ),
//                             ],
//
//                             const SizedBox(height: 16),
//
//                             GestureDetector(
//                               onTap: () => setState(() => _isLogin = !_isLogin),
//                               child: Text(
//                                 _isLogin
//                                     ? "Don't have an account? Sign up"
//                                     : "Already have an account? Login",
//                                 style: TextStyle(
//                                   color: isDark
//                                       ? Colors.cyanAccent
//                                       : Colors.deepPurple,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
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
//   /// 🔵 Neon glowing orb
//   Widget _glowingOrb(double size, Color color) {
//     return Container(
//       height: size,
//       width: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: color,
//         boxShadow: [BoxShadow(color: color, blurRadius: 80, spreadRadius: 30)],
//       ),
//     );
//   }
//
//   /// 📝 Futuristic Input Decoration
//   InputDecoration _inputDecoration(String label, IconData icon, bool isDark) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
//       prefixIcon: Icon(
//         icon,
//         color: isDark ? Colors.cyanAccent : Colors.deepPurple,
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(
//           color: isDark ? Colors.cyanAccent : Colors.purpleAccent,
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(
//           color: isDark ? Colors.cyanAccent : Colors.deepPurple,
//           width: 2,
//         ),
//       ),
//       filled: true,
//       fillColor: isDark
//           ? Colors.black.withOpacity(0.3)
//           : Colors.white.withOpacity(0.7),
//     );
//   }
// }









































import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import 'package:another_flushbar/flushbar.dart'; // ✅ Flushbar
import '../features/authRepositoryProvider.dart';
import 'AuthGate.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  bool _isLogin = true;
  bool _playButtonAnimation = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  /// 🌟 Flushbar Helper
  void _showFlushbar(
      BuildContext context, {
        required String title,
        required String message,
        bool isError = false,
      }) {
    Flushbar(
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(14),
      backgroundGradient: LinearGradient(
        colors: isError
            ? [const Color(0xFFEF4444), const Color(0xFFF87171)] // red gradient
            : [const Color(0xFF8B5CF6), const Color(0xFF6EE7F9)], // purple → cyan
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadows: [
        BoxShadow(
          color: (isError ? Colors.redAccent : Colors.cyanAccent)
              .withOpacity(0.4),
          offset: const Offset(0, 4),
          blurRadius: 10,
        ),
      ],
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 15,
        ),
      ),
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle,
        color: Colors.white,
        size: 28,
      ),
      animationDuration: const Duration(milliseconds: 400),
    ).show(context);
  }


  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final name = _name.text.trim();
    final email = _email.text.trim();
    final pass = _password.text;

    try {
      if (_isLogin) {
        await ref.read(authControllerProvider.notifier).signIn(email, pass);
      } else {
        await ref.read(authControllerProvider.notifier).signUp(name ,email, pass);

        final user = FirebaseAuth.instance.currentUser;
        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();
          if (context.mounted) {
            _showFlushbar(
              context,
              title: "Verification Sent",
              message: "Check your inbox to verify before login.",
              isError: false,
            );
          }
          return;
        }
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user != null && (_isLogin || user.emailVerified) && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthGate()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;

      switch (e.code) {
        case 'wrong-password':
          _showFlushbar(
            context,
            title: "Wrong Password",
            message: "The password you entered is incorrect.",
            isError: true,
          );
          break;
        case 'email-already-in-use':
          _showFlushbar(
            context,
            title: "Account Exists",
            message: "This email is already registered.",
            isError: true,
          );
          break;
        case 'user-not-found':
          _showFlushbar(
            context,
            title: "No Account Found",
            message: "Please sign up before logging in.",
            isError: true,
          );
          break;
        case 'invalid-email':
          _showFlushbar(
            context,
            title: "Invalid Email",
            message: "The email format is incorrect.",
            isError: true,
          );
          break;
        case 'invalid-credential':
          _showFlushbar(
            context,
            title: "Invalid Credentials",
            message: "The credentials provided are invalid.",
            isError: true,
          );
          break;
        default:
          _showFlushbar(
            context,
            title: "Authentication Error",
            message: e.message ?? "An unknown error occurred.",
            isError: true,
          );
      }
    } catch (e) {
      if (!context.mounted) return;

      print("Unexpected error: $e"); // Optional debug info

      _showFlushbar(
        context,
        title: "Login Error",
        message: "Unexpected error. Please try again.",
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Animated background gradient
          AnimatedContainer(
            duration: const Duration(seconds: 3),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                  const Color(0xFF0f172a),
                  const Color(0xFF1e293b),
                  Colors.black,
                ]
                    : [
                  const Color(0xFFe0e7ff),
                  const Color(0xFFfdf4ff),
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Floating background glowing orb
          Positioned(
            top: 80,
            left: -40,
            child: _glowingOrb(120, Colors.purpleAccent.withOpacity(0.3)),
          ),
          Positioned(
            bottom: 100,
            right: -30,
            child: _glowingOrb(180, Colors.cyanAccent.withOpacity(0.25)),
          ),

          // Glassmorphic card with animated size
          Center(
            child: FadeInUp(
              duration: const Duration(milliseconds: 800),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),

                  // AnimatedSize wraps the card to animate height changes
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: Container(
                      width: 380,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isDark
                              ? Colors.cyanAccent.withOpacity(0.4)
                              : Colors.purpleAccent.withOpacity(0.4),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            isDark
                                ? Colors.black.withOpacity(0.5)
                                : Colors.white.withOpacity(0.5),
                            isDark
                                ? Colors.black.withOpacity(0.2)
                                : Colors.white.withOpacity(0.3),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),

                      // Scrollable form content
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Lottie animation at top
                              SizedBox(
                                height: 140,
                                child: Lottie.asset(
                                  _isLogin
                                      ? 'assets/lottie/login.json'
                                      : 'assets/lottie/createacca.json',
                                  repeat: true,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Animated title switch between Login and Sign Up
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                transitionBuilder: (child, animation) =>
                                    FadeTransition(
                                      opacity: animation,
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0.0, 0.3),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      ),
                                    ),
                                child: Text(
                                  _isLogin
                                      ? "Welcome Back"
                                      : "Create Account",
                                  key: ValueKey(_isLogin),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),


                              if (!_isLogin)
                                SlideInLeft(
                                  child: TextFormField(
                                    controller: _name,
                                    style: TextStyle(
                                      color: isDark ? Colors.white : Colors.black,
                                    ),
                                    decoration: _inputDecoration(
                                      "Full Name",
                                      Icons.person_outline,
                                      isDark,
                                    ),
                                    validator: (v) {
                                      if (_isLogin) return null;
                                      return (v != null && v.trim().length >= 2)
                                          ? null
                                          : 'Enter your name';
                                    },
                                  ),
                                ),
                              const SizedBox(height: 16),





                              // Email TextField
                              SlideInLeft(
                                child: TextFormField(
                                  controller: _email,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  decoration: _inputDecoration(
                                    "Email",
                                    Icons.email_outlined,
                                    isDark,
                                  ),
                                  validator: (v) => v != null &&
                                      v.contains('@')
                                      ? null
                                      : 'Enter a valid email',
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Password TextField
                              SlideInRight(
                                child: TextFormField(
                                  controller: _password,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  decoration: _inputDecoration(
                                    "Password",
                                    Icons.lock_outline,
                                    isDark,
                                  ),
                                  obscureText: true,
                                  validator: (v) => v != null &&
                                      v.length >= 6
                                      ? null
                                      : 'Min 6 characters',
                                ),
                              ),
                              const SizedBox(height: 20),

                              if (state.error != null)
                                Text(
                                  state.error!,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),

                              const SizedBox(height: 12),

                              // Submit button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                  onPressed: state.loading
                                      ? null
                                      : () {
                                    setState(() {
                                      _playButtonAnimation = true;
                                    });
                                    _submit(context).then((_) {
                                      Future.delayed(
                                        const Duration(seconds: 2),
                                            () {
                                          if (mounted) {
                                            setState(() =>
                                            _playButtonAnimation =
                                            false);
                                          }
                                        },
                                      );
                                    });
                                  },
                                  child: state.loading
                                      ? SizedBox(
                                    height: 50,
                                    child: Lottie.asset(
                                      'assets/lottie/loading.json',
                                    ),
                                  )
                                      : Ink(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          isDark
                                              ? Colors.cyanAccent
                                              : Colors.purpleAccent,
                                          isDark
                                              ? Colors.blueAccent
                                              : Colors.deepPurple,
                                        ],
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(16),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 60,
                                      child: _playButtonAnimation
                                          ? Transform.scale(
                                        scale: 1.4,
                                        child: Lottie.asset(
                                          _isLogin
                                              ? 'assets/lottie/loading.json'
                                              : 'assets/lottie/sentmail.json',
                                          height: 60,
                                          fit: BoxFit.contain,
                                          repeat: false,
                                        ),
                                      )
                                          : Text(
                                        _isLogin
                                            ? "Login"
                                            : "Sign Up",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight:
                                          FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              // Animated Resend Email button only visible in Sign Up
                              AnimatedSwitcher(
                                duration:
                                const Duration(milliseconds: 300),
                                child: !_isLogin
                                    ? Column(
                                  key: const ValueKey("resend"),
                                  children: [
                                    ElevatedButton(
                                      style:
                                      ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        shape:
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              8),
                                        ),
                                        backgroundColor:
                                        Colors.transparent,
                                        shadowColor:
                                        Colors.transparent,
                                        elevation: 6,
                                      ),
                                      onPressed: () {
                                        final user = FirebaseAuth
                                            .instance.currentUser;

                                        if (user != null &&
                                            !user.emailVerified) {
                                          user
                                              .sendEmailVerification();
                                          _showFlushbar(
                                            context,
                                            title:
                                            "Verification Sent",
                                            message:
                                            "Please check your email inbox.",
                                            isError: false,
                                          );
                                        }

                                        Navigator
                                            .pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                            const AuthGate(),
                                          ),
                                        );
                                      },
                                      child: Ink(
                                        decoration:
                                        BoxDecoration(
                                          gradient:
                                          const LinearGradient(
                                            colors: [
                                              Color(0xFF6EE7F9),
                                              Color(0xFF5CF69F),
                                            ],
                                            begin: Alignment
                                                .topLeft,
                                            end: Alignment
                                                .bottomRight,
                                          ),
                                          borderRadius:
                                          BorderRadius
                                              .circular(8),
                                        ),
                                        child: Container(
                                          alignment:
                                          Alignment.center,
                                          padding:
                                          const EdgeInsets
                                              .symmetric(
                                            vertical: 8,
                                          ),
                                          child: const Text(
                                            "Resend Email",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.bold,
                                              color: Colors.black,
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                    : const SizedBox.shrink(
                                  key: ValueKey("empty"),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Toggle login/signup text
                              GestureDetector(
                                onTap: () => setState(
                                      () => _isLogin = !_isLogin,
                                ),
                                child: Text(
                                  _isLogin
                                      ? "Don't have an account? Sign up"
                                      : "Already have an account? Login",
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.cyanAccent
                                        : Colors.deepPurple,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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





























  /// 🔵 Neon glowing orb
  Widget _glowingOrb(double size, Color color) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 80, spreadRadius: 30)],
      ),
    );
  }

  /// 📝 Futuristic Input Decoration
  InputDecoration _inputDecoration(String label, IconData icon, bool isDark) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
      prefixIcon: Icon(
        icon,
        color: isDark ? Colors.cyanAccent : Colors.deepPurple,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? Color(0xff2d3a64) : Colors.purpleAccent,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? Colors.cyanAccent : Colors.deepPurple,
          width: 2,
        ),
      ),
      filled: true,
      fillColor: isDark
          ? Colors.black.withOpacity(0.3)
          : Colors.white.withOpacity(0.7),
    );
  }
}
