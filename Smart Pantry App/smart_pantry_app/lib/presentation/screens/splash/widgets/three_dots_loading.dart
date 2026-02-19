import 'package:flutter/material.dart';

/// A custom stateful widget that displays a three-dot sequential loading animation.
///
/// This widget uses an [AnimationController] to create a fluid, repetitive
/// opacity transition across three circular dots, signaling a background process
/// to the user without using a standard progress indicator.
class ThreeDotsLoading extends StatefulWidget {
  /// Creates a [ThreeDotsLoading] instance.
  const ThreeDotsLoading({super.key});

  @override
  State<ThreeDotsLoading> createState() => _ThreeDotsLoadingState();
}

class _ThreeDotsLoadingState extends State<ThreeDotsLoading>
    with SingleTickerProviderStateMixin {
  /// Controller that manages the timeline of the animation.
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with a 1-second duration and set it to repeat indefinitely.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    // Ensure the controller is disposed to prevent memory leaks and ticker errors.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            // Logic to calculate sequential opacity based on the animation's current value.
            // This creates a "travelling" light effect across the dots.
            double opacity = ((_controller.value * 3 - index).clamp(0.0, 1.0));

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                // Maintains a minimum visibility (0.3) even when "inactive"
                color: Colors.white.withOpacity(opacity < 0.3 ? 0.3 : opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
