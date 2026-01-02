import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/deep_space_background.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to OnboardingScreen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const DeepSpaceBackground(child: SizedBox.expand()),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  'Float',
                  style: GoogleFonts.outfit(
                    fontSize: 48,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                )
                .animate()
                .fadeIn(
                  duration: 2.seconds,
                  delay: 1.seconds,
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
                .animate()
                .moveY(
                  begin: 300,
                  end: 0,
                  duration: 2.5.seconds,
                  curve: Curves.easeOut,
                )
                .fadeOut(
                  delay: 2.seconds,
                  duration: 500.ms, // 500ms
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
