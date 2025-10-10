import 'package:flutter/material.dart';

class DustBackground extends StatelessWidget {
  const DustBackground({
    super.key,
    this.assetPath = 'assets/images/img_1.png',
    this.opacity = 0.06,
  });

  final String assetPath;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          image: DecorationImage(
            image: AssetImage(assetPath),
            repeat: ImageRepeat.repeat,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(opacity),
              BlendMode.srcATop,
            ),
          ),
        ),
      ),
    );
  }
}