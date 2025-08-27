import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'LoginScreen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  // Future<void> _finishIntro() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool("seenIntro", true);
  //
  //   if (!mounted) return;
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (_) => const Homescreen()),
  //   );
  // }
  Future<void> _finishIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("seenIntro", true);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()), // 👈 go to Login instead of Home
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => isLastPage = index == 2);
            },
            children: [
              buildPage(
                color1: Colors.deepPurple,
                color2: Colors.purpleAccent,
                lottiePath: "assets/lottie/scan.json",
               // lottie: "https://assets7.lottiefiles.com/packages/lf20_totrpclr.json",
                title: "Scan with Ease",
                subtitle: "Quickly capture text from any business card.",
                //lottie: '',
              ),
              buildPage(
                color1: Colors.indigo,
                color2: Colors.blueAccent,
               // lottie: "https://assets7.lottiefiles.com/packages/lf20_iwmd6pyr.json",
                title: "Smart Recognition",
                subtitle: "AI-powered parser organizes details automatically.",
                lottiePath: "assets/lottie/artificialintelligence.json",
              ),
              buildPage(
                color1: Colors.teal,
                color2: Colors.greenAccent,
                // lottie: "https://assets7.lottiefiles.com/packages/lf20_totrpclr.json",
                title: "Save & Share",
                subtitle: "Store contacts securely and share in one tap.",
                lottiePath: "assets/lottie/refferal.json",
              ),
            ],
          ),

          // Indicator + Button
          Container(
            alignment: const Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Skip
                TextButton(
                  onPressed: _finishIntro,
                  child: const Text("Skip", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),

                // Indicator
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Colors.white,
                    dotColor: Colors.white54,
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),

                // Next / Done
                isLastPage
                    ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: _finishIntro,
                  child: const Text("Get Started"),
                )
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () async {
                    final lastPageIndex = 2;
                    if (_controller.page == lastPageIndex) {
                      // ✅ Save that intro has been seen
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool("seenIntro", true);

                      // ✅ Navigate to LoginPage
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    } else {
                      // ✅ Go to next page as usual
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    }
                  },child: const Text("Next"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage({
    required Color color1,
    required Color color2,
    // required String lottie,
    required String title,
    required String subtitle,
    required String lottiePath,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(lottiePath, height: 220),
        //  Lottie.network(lottie, height: 250),
          const SizedBox(height: 30),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
