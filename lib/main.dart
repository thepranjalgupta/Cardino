import 'package:cardo/screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';


import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cardino',
        theme: ThemeData.light().copyWith(
          primaryColor: Color(0xff2d3a64),
          scaffoldBackgroundColor: Colors.white,
          cardColor: Colors.white,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black),
            bodyMedium: TextStyle(color: Colors.black87),
            titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF8B5CF6),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),

        // 🌙 Dark theme
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: Color(0xFF6EE7F9),

          scaffoldBackgroundColor: Colors.black,
          cardColor: const Color(0xFF1E1E1E),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white70),
            titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),

        themeMode: ThemeMode.system,

        // theme: ThemeData.dark().copyWith(
        //   primaryColor: Colors.deepPurple, // appbar + accent
        //   scaffoldBackgroundColor: const Color(0xFF121212), // dark bg
        //   cardColor: const Color(0xFF1E1E1E), // card bg
        //   textTheme: const TextTheme(
        //     bodyLarge: TextStyle(color: Colors.white),
        //     bodyMedium: TextStyle(color: Colors.white70),
        //     titleLarge: TextStyle(color: Colors.white),
        //   )
        // ),
        home: const SplashScreen(appName: "Cardino...")
      //AuthGate(),
      //SplashScreen(appName: 'Cardium',),
    );
  }
}
