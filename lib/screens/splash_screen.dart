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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          const DeepSpaceBackground(child: SizedBox.expand()),

          // Rising Bubble Animation
          // Starts at bottom center, moves to center, fades out
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            )
            .animate()
            .moveY(
              begin: 0, 
              end: -size.height / 2, // Move up to center (approx)
              duration: 2.5.seconds,
              curve: Curves.easeInOut,
            )
            .fadeOut(
              duration: 2.5.seconds,
              curve: Curves.easeIn,
            ),
          ),

          // Title Text
          // Fades in slowly
          Center(
            child: Text(
              'Float',
              style: GoogleFonts.outfit(
                fontSize: 48,
                fontWeight: FontWeight.w100, // Thin
                letterSpacing: 4.0,
                color: Colors.white,
              ),
            )
            .animate()
            .fadeIn(
              duration: 2.seconds,
              curve: Curves.easeIn,
            ),
          ),
        ],
      ),
    );
  }
}
