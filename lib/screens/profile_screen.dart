import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../widgets/deep_space_background.dart';
import '../utils/audio_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _soundEnabled = true;
  bool _hapticEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const DeepSpaceBackground(child: SizedBox.expand()),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // 1. Header
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      Expanded(
                        child: Text(
                          'Pilot Log',
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48), // Balance the back button
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 2. Avatar Section
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1.5,
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.1),
                                  Colors.white.withOpacity(0.05),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                '🚀',
                                style: TextStyle(fontSize: 50),
                              ),
                            ),
                          ),
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .moveY(
                        begin: -5,
                        end: 5,
                        duration: 3.seconds,
                        curve: Curves.easeInOut,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Cosmic Traveler',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // 3. Stats Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      _GlassStatCard(
                        label: 'Total Pops',
                        numericValue: 1240,
                        suffix: '',
                      ),
                      const _GlassStatCard(
                        label: 'Current Orbit',
                        numericValue: 12,
                        suffix: ' Days',
                      ),
                      const _GlassStatCard(
                        label: 'Best Orbit',
                        numericValue: 45,
                        suffix: ' Days',
                      ),
                      const _GlassStatCard(
                        label: 'Completion',
                        numericValue: 92,
                        suffix: '%',
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // 4. Settings Section
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: Text(
                                'Sound Effects',
                                style: GoogleFonts.outfit(color: Colors.white),
                              ),
                              value: _soundEnabled,
                              onChanged: (val) {
                                setState(() => _soundEnabled = val);
                                AudioManager.instance.toggleMute(!val);
                              },
                              activeColor: Colors.white,
                              activeTrackColor: Theme.of(context).primaryColor,
                            ),
                            Divider(color: Colors.white.withOpacity(0.1), height: 1),
                            SwitchListTile(
                              title: Text(
                                'Haptic Feedback',
                                style: GoogleFonts.outfit(color: Colors.white),
                              ),
                              value: _hapticEnabled,
                              onChanged: (val) => setState(() => _hapticEnabled = val),
                              activeColor: Colors.white,
                              activeTrackColor: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
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
}

class _GlassStatCard extends StatelessWidget {
  final String label;
  final num numericValue;
  final String suffix;

  const _GlassStatCard({
    required this.label,
    required this.numericValue,
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TweenAnimationBuilder<num>(
                tween: Tween<num>(begin: 0, end: numericValue),
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeOutExpo,
                builder: (context, value, child) {
                  final formattedValue = NumberFormat.decimalPattern().format(value.toInt());
                  return Text(
                    '$formattedValue$suffix',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
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
          ),
        ),
      ),
    );
  }
}
