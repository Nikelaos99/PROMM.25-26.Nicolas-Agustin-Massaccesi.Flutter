import 'package:flutter/material.dart';

class ThreeDotsLoading extends StatefulWidget {
  const ThreeDotsLoading({super.key});

  @override
  State<ThreeDotsLoading> createState() => _ThreeDotsLoadingState();
}

class _ThreeDotsLoadingState extends State<ThreeDotsLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
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
            // Crea el efecto de secuencia (0.0 a 1.0)
            double opacity = ((_controller.value * 3 - index).clamp(0.0, 1.0));
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
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
