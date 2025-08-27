// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'HomeScreen.dart';
// import 'IntroScreen.dart';
//
// class SplashScreen extends StatefulWidget {
//   final String appName;
//   final Duration showFor;
//   const SplashScreen({
//     super.key,
//     required this.appName,
//     this.showFor = const Duration(milliseconds: 3000),
//   });
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _ctrl;
//   late final Animation<double> _fade;
//   late final Animation<double> _scale;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..forward();
//
//     _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
//     _scale = Tween<double>(begin: 0.98, end: 1.0)
//         .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
//
//     // Navigate after delay
//     Future.delayed(widget.showFor, () async {
//       if (!mounted) return;
//
//       final prefs = await SharedPreferences.getInstance();
//       final seenIntro = prefs.getBool("seenIntro") ?? false;
//
//       if (seenIntro) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (_) => const Homescreen()), // ✅ If intro already seen → go Home
//         );
//       } else {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (_) => const IntroScreen()), // ✅ Otherwise → go Intro
//         );
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final text = widget.appName;
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Center(
//           child: ScaleTransition(
//             scale: _scale,
//             child: FadeTransition(
//               opacity: _fade,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Typewriter animation
//                   TweenAnimationBuilder<int>(
//                     tween: IntTween(begin: 0, end: text.length),
//                     duration: const Duration(milliseconds: 1500),
//                     builder: (context, value, child) {
//                       return ShaderMask(
//                         shaderCallback: (rect) => const LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             Color(0xFF6EE7F9), // cyan
//                             Color(0xFF8B5CF6), // violet
//                           ],
//                         ).createShader(rect),
//                         child: Text(
//                           text.substring(0, value),
//                           style: const TextStyle(
//                             fontSize: 46,
//                             fontWeight: FontWeight.w800,
//                             letterSpacing: 0.8,
//                             color: Colors.white, // masked
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   // Subtext fade-in
//                   TweenAnimationBuilder<double>(
//                     tween: Tween(begin: 0, end: 1),
//                     duration: const Duration(milliseconds: 900),
//                     curve: Curves.easeOut,
//                     builder: (context, value, child) => Opacity(
//                       opacity: value,
//                       child: child,
//                     ),
//                     child: const Text(
//                       'Scan. Save. Manage.',
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.white70,
//                         letterSpacing: 0.6,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 32),
//                   // Progress pulse
//                   TweenAnimationBuilder<double>(
//                     tween: Tween(begin: 0.8, end: 1.0),
//                     duration: const Duration(milliseconds: 700),
//                     curve: Curves.easeInOut,
//                     builder: (context, value, child) => Transform.scale(
//                       scale: value,
//                       child: child,
//                     ),
//                     child: const Icon(Icons.blur_on, size: 20, color: Colors.white54),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'AuthGate.dart';
import 'HomeScreen.dart';
import 'IntroScreen.dart';
import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  final String appName;
  final Duration showFor;
  const SplashScreen({
    super.key,
    required this.appName,
    this.showFor = const Duration(milliseconds: 3000),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.98, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));

    // Updated logic: wait for async calls then navigate
    _checkAndNavigate();
  }

  Future<void> _checkAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final seenIntro = prefs.getBool("seenIntro") ?? false;
    final user = FirebaseAuth.instance.currentUser;

    // Wait at least for the splash duration to show animation nicely
    await Future.delayed(widget.showFor);

    if (!mounted) return;


    if (!seenIntro) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const IntroScreen()),
      );
      return;
    }

    if (user == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      return;
    }

    if (!user.emailVerified) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthGate()),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const Homescreen()),
    );
  }

  // Future<void> _checkAndNavigate() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final seenIntro = prefs.getBool("seenIntro") ?? false;
  //   final user = FirebaseAuth.instance.currentUser;
  //
  //   await Future.delayed(widget.showFor);
  //   if (!mounted) return;
  //
  //   print("Splash complete. seenIntro=$seenIntro, user=$user");
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     print("Inside post frame callback");
  //
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(
  //         builder: (_) => const Scaffold(
  //           body: Center(child: Text("Intro Placeholder")),
  //         ),
  //       ),
  //     );
  //
  //
  //
  //
  //
  //   }
  //   );
  // }




  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.appName;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: ScaleTransition(
            scale: _scale,
            child: FadeTransition(
              opacity: _fade,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: text.length),
                    duration: const Duration(milliseconds: 1500),
                    builder: (context, value, child) {
                      return ShaderMask(
                        shaderCallback: (rect) => const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF6EE7F9),
                            Color(0xFF8B5CF6),
                          ],
                        ).createShader(rect),
                        child: Text(
                          text.substring(0, value),
                          style: const TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOut,
                    builder: (context, value, child) => Opacity(
                      opacity: value,
                      child: child,
                    ),
                    child: const Text(
                      'Scan. Save. Manage.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.8, end: 1.0),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) => Transform.scale(
                      scale: value,
                      child: child,
                    ),
                    child: const Icon(Icons.blur_on, size: 20, color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
