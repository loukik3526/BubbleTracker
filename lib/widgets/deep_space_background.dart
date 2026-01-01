import 'package:flutter/material.dart';

class DeepSpaceBackground extends StatelessWidget {
  final Widget child;

  const DeepSpaceBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E1B4B), // Deep Violet
            Color(0xFF000000), // Pure Black
          ],
        ),
      ),
      child: child,
    );
  }
}
