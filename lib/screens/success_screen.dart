import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/deep_space_background.dart';
import 'home_screen.dart';
import 'summary_screen.dart';

class SuccessScreen extends StatelessWidget {
  final int completedCount;
  final String estimatedTime;
  final int streak;

  const SuccessScreen({
    super.key,
    required this.completedCount,
    required this.estimatedTime,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background with Particles
          const DeepSpaceBackground(child: SizedBox.expand()),
          const _ParticleOverlay(),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  
                  // 2. Header Content
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: const Text(
                          '✨',
                          style: TextStyle(fontSize: 40),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.2, 1.2),
                          duration: (1.5 + index * 0.2).seconds, // Staggered pulsing
                          curve: Curves.easeInOut,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Zero Gravity Achieved',
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your day is balanced.',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // 3. Stats Card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem('Completed', '$completedCount'),
                            _buildStatItem('Time', estimatedTime),
                            _buildStatItem('Streak', '$streak'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const Spacer(),

                  // 4. Footer Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SummaryScreen()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Text(
                        'View Summary',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }
}

class _ParticleOverlay extends StatelessWidget {
  const _ParticleOverlay();

  @override
  Widget build(BuildContext context) {
    final random = Random();
    return Stack(
      children: List.generate(20, (index) {
        final size = random.nextDouble() * 3 + 1;
        final left = random.nextDouble() * MediaQuery.of(context).size.width;
        final top = random.nextDouble() * MediaQuery.of(context).size.height;
        final duration = random.nextInt(5) + 5; // 5-10 seconds

        return Positioned(
          left: left,
          top: top,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(random.nextDouble() * 0.5 + 0.1),
              shape: BoxShape.circle,
            ),
          )
          .animate(onPlay: (c) => c.repeat())
          .moveY(
            begin: 0,
            end: -100, // Move up
            duration: duration.seconds,
          )
          .fadeIn(duration: 1.seconds)
          .fadeOut(delay: (duration - 1).seconds, duration: 1.seconds),
        );
      }),
    );
  }
}
