// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:visi_scan/screens/HomeScreen.dart';
// import 'package:visi_scan/screens/LoginScreen.dart';
// import '../features/firebaseAuthProvider.dart';
//
// class AuthGate extends ConsumerWidget {
//   const AuthGate({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authAsync = ref.watch(authStateChangesProvider);
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return authAsync.when(
//       model: (User? user) {
//         if (user == null) {
//           return const LoginPage(); // Not logged in
//         }
//
//         if (!user.emailVerified) {
//           // Logged in, but not verified
//           return Scaffold(
//             body: Center(
//               child: ClipRRect(
//                 // Decorative glass panel
//                 borderRadius: BorderRadius.circular(24),
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
//                   child: Container(
//                     width: 320,
//                     padding: const EdgeInsets.all(24),
//                     decoration: BoxDecoration(
//                       color: isDark
//                           ? Colors.black.withOpacity(0.4)
//                           : Colors.white.withOpacity(0.4),
//                       borderRadius: BorderRadius.circular(24),
//                       border: Border.all(
//                         color: isDark
//                             ? Colors.white.withOpacity(0.2)
//                             : Colors.black.withOpacity(0.2),
//                       ),
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         AnimatedSwitcher(
//                           duration: const Duration(milliseconds: 300),
//                           child: const Text(
//                             "Please verify your email before continuing.",
//                             key: ValueKey('verifyText'),
//                             textAlign: TextAlign.center,
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             backgroundColor: Colors.transparent,
//                             shadowColor: Colors.transparent,
//                           ),
//                           onPressed: () async {
//                             await user.sendEmailVerification();
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text("Verification email sent")),
//                             );
//                           },
//                           child: Ink(
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: isDark
//                                     ? [Colors.cyanAccent, Colors.blueAccent]
//                                     : [Colors.purpleAccent, Colors.deepPurple],
//                               ),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Container(
//                               alignment: Alignment.center,
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                               child: const Text(
//                                 "Resend verification email",
//                                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             backgroundColor: Colors.transparent,
//                             shadowColor: Colors.transparent,
//                           ),
//                           onPressed: () async {
//                             await user.reload();
//                             final refreshed = FirebaseAuth.instance.currentUser;
//                             if (refreshed != null && refreshed.emailVerified) {
//                               ref.refresh(authStateChangesProvider);
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(content: Text("Email not verified yet")),
//                               );
//                             }
//                           },
//                           child: Ink(
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: isDark
//                                     ? [Colors.greenAccent, Colors.tealAccent]
//                                     : [Colors.blueAccent, Colors.indigo],
//                               ),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Container(
//                               alignment: Alignment.center,
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                               child: const Text(
//                                 "Continue",
//                                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }
//
//         return const Homescreen(); // Verified and logged in
//       },
//       error: (e, _) => Scaffold(body: Center(child: Text('Auth error: $e'))),
//       loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
//     );
//   }
// }

//
// import 'dart:ui';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:visi_scan/screens/HomeScreen.dart';
// import 'package:visi_scan/screens/LoginScreen.dart';
// import '../features/firebaseAuthProvider.dart';
//
// class AuthGate extends ConsumerStatefulWidget {
//   const AuthGate({super.key});
//
//   @override
//   ConsumerState<AuthGate> createState() => _AuthGateState();
// }
//
// class _AuthGateState extends ConsumerState<AuthGate> with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _animationController = AnimationController(
//       duration: const Duration(seconds: 20),
//       vsync: this,
//     )..repeat(reverse: true);
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final authAsync = ref.watch(authStateChangesProvider);
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;
//
//     return AnimatedBuilder(
//       animation: _animationController,
//
//       builder: (context, child) {
//         final dx = sin(_animationController.value * 2 * pi) * 50;
//         final dy = cos(_animationController.value * 2 * pi) * 50;
//
//         return Stack(
//           children: [
//             AnimatedContainer(
//               duration: const Duration(seconds: 1),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     theme.colorScheme.primary.withOpacity(0.2),
//                     theme.colorScheme.secondary.withOpacity(0.2),
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 100 + dy,
//               left: 100 + dx,
//               child: Container(
//                 width: 200,
//                 height: 200,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: theme.colorScheme.primary.withOpacity(0.1),
//                 ),
//               ),
//             ),
//             authAsync.when(
//               model: (User? user) {
//                 if (user == null) {
//                   return const LoginPage(); // Not logged in
//                 }
//
//                 if (!user.emailVerified) {
//                   return Scaffold(
//                     backgroundColor: Colors.transparent,
//                     body: Center(
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(24),
//                         child: BackdropFilter(
//                           filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//                           child: Container(
//                             width: 340,
//                             padding: const EdgeInsets.all(24),
//                             decoration: BoxDecoration(
//                               color: theme.colorScheme.background.withOpacity(0.6),
//                               borderRadius: BorderRadius.circular(24),
//                               border: Border.all(
//                                 color: theme.dividerColor.withOpacity(0.2),
//                               ),
//                             ),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 const Text(
//                                   "Please verify your email before continuing.",
//                                   key: ValueKey('verifyText'),
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                                 ),
//                                 const SizedBox(height: 24),
//                                 ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     backgroundColor: Colors.transparent,
//                                     shadowColor: Colors.transparent,
//                                   ),
//                                   onPressed: () async {
//                                     await user.sendEmailVerification();
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(content: Text("Verification email sent")),
//                                     );
//                                   },
//                                   child: Ink(
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         colors: isDark
//                                             ? [Colors.cyanAccent, Colors.blueAccent]
//                                             : [Colors.purpleAccent, Colors.deepPurple],
//                                       ),
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     child: Container(
//                                       alignment: Alignment.center,
//                                       padding: const EdgeInsets.symmetric(vertical: 12),
//                                       child: const Text(
//                                         "Resend verification email",
//                                         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 16),
//                                 ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     backgroundColor: Colors.transparent,
//                                     shadowColor: Colors.transparent,
//                                   ),
//                                   onPressed: () async {
//                                     await user.reload();
//                                     final refreshed = FirebaseAuth.instance.currentUser;
//                                     if (refreshed != null && refreshed.emailVerified) {
//                                       ref.refresh(authStateChangesProvider);
//                                     } else {
//                                       ScaffoldMessenger.of(context).showSnackBar(
//                                         const SnackBar(content: Text("Email not verified yet")),
//                                       );
//                                     }
//                                   },
//                                   child: Ink(
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         colors: isDark
//                                             ? [Colors.teal, Colors.tealAccent]
//                                             : [Colors.blueAccent, Colors.indigo],
//                                       ),
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     child: Container(
//                                       alignment: Alignment.center,
//                                       padding: const EdgeInsets.symmetric(vertical: 12),
//                                       child: const Text(
//                                         "Continue",
//                                         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//
//                 return const Homescreen(); // Verified and logged in
//               },
//               error: (e, _) => Scaffold(body: Center(child: Text('Auth error: $e'))),
//               loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../features/firebaseAuthProvider.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authStateChangesProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;







    //snakbar theme
    void showFuturisticSnackBar(BuildContext context, String message) {
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
            color: isDark ? Colors.cyanAccent.withOpacity(0.8) : Colors.indigoAccent.withOpacity(0.8),
            width: 1.5,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: isDark ? Colors.cyanAccent.shade100 : Colors.indigo.shade900,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }








    return authAsync.when(
      data: (User? user) {
        if (user == null) {
          return const LoginPage(); // Not logged in
        }

        if (!user.emailVerified) {
          // Logged in, but not verified
          return Scaffold(
            backgroundColor: Colors.black, // Pure black background
            body: Stack(
              fit: StackFit.expand,
              children: [
                // Animated glowing blobs background
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _BlobPainter(_animation.value, isDark),
                    );
                  },
                ),

                // Glass panel with verification UI
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        width: 320,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.black.withOpacity(0.4)
                              : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.2)
                                : Colors.black.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: const Text(
                                "Please verify your email before continuing.",
                                key: ValueKey('verifyText'),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              onPressed: () async {
                                await user.sendEmailVerification();
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   const SnackBar(content: Text("Verification email sent")),
                                // );
                                showFuturisticSnackBar(context, "Verification mail resent!");
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isDark
                                        ? [Colors.cyanAccent, Colors.blueAccent]
                                        : [Colors.purpleAccent, Colors.deepPurple],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: const Text(
                                    "Resend verification email",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              onPressed: () async {
                                await user.reload();
                                final refreshed = FirebaseAuth.instance.currentUser;
                                if (refreshed != null && refreshed.emailVerified) {
                                  ref.refresh(authStateChangesProvider);
                                } else {
                                  showFuturisticSnackBar(context, "Email not verified yet");

                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(content: Text("Email not verified yet")),
                                  // );
                                }
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isDark
                                        ? [Colors.greenAccent, Colors.tealAccent]
                                        : [Colors.blueAccent, Colors.indigo],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: const Text(
                                    "Continue",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (_) => const LoginPage()),
                                );
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isDark
                                        ? [Colors.redAccent, Colors.orangeAccent]
                                        : [Colors.deepOrange, Colors.orange],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: const Text(
                                    "Back to Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const Homescreen(); // Verified and logged in
      },
      error: (e, _) => Scaffold(body: Center(child: Text('Auth error: $e'))),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
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

    // Blob 1: Large, glowing purple-blue
    final blob1Center = Offset(size.width * 0.3, size.height * 0.4);
    final blob1Radius = 180 + 20 * animationValue;

    paint.shader = RadialGradient(
      colors: [
        (isDark ? Colors.purpleAccent : Colors.deepPurple).withOpacity(0.6 * animationValue),
        Colors.transparent,
      ],
      stops: const [0.0, 1.0],
    ).createShader(Rect.fromCircle(center: blob1Center, radius: blob1Radius));

    canvas.drawCircle(blob1Center, blob1Radius, paint);

    // Blob 2: Smaller, glowing cyan-green
    final blob2Center = Offset(size.width * 0.7, size.height * 0.7);
    final blob2Radius = 120 + 15 * animationValue;

    paint.shader = RadialGradient(
      colors: [
        (isDark ? Colors.cyanAccent : Colors.blueAccent).withOpacity(0.5 * animationValue),
        Colors.transparent,
      ],
      stops: const [0.0, 1.0],
    ).createShader(Rect.fromCircle(center: blob2Center, radius: blob2Radius));

    canvas.drawCircle(blob2Center, blob2Radius, paint);
  }

  @override
  bool shouldRepaint(covariant _BlobPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue || oldDelegate.isDark != isDark;
  }
}

