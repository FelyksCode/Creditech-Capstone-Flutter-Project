import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'glassy_card.dart';
import 'package:creditech_capstone_project/ui/widgets/dust_background.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.expand(
        child: Stack(
          children: [
            const Positioned.fill(
              child: DustBackground(
                assetPath: 'assets/images/img_1.png',
                opacity: 0.06,
              ),
            ),
        
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    const SizedBox(height: 28),
        
                    const GlassyCard(),
                    const SizedBox(height: 42),
        
                    const Text(
                      'This Month',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 18),
        
                    const _Chart(fraudRatio: 0.5, totalText: '—'),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good evening,',
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
        SizedBox(height: 2),
        Text(
          'User',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart({
    required this.fraudRatio,
    this.totalText = '—',
    this.fraudColor = const Color(0xFFE74C3C),
    this.safeColor = const Color(0xFF4169E1),
  });

  final double fraudRatio;
  final String totalText;
  final Color fraudColor;
  final Color safeColor;

  @override
  Widget build(BuildContext context) {
    final sweepFraud = 2 * pi * fraudRatio.clamp(0.0, 1.0);
    final sweepSafe = 2 * pi - sweepFraud;

    return Center(
      child: SizedBox(
        width: 240,
        height: 240,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),

            _arc(color: fraudColor, start: -pi / 2, sweep: sweepFraud),

            _arc(
              color: safeColor,
              start: -pi / 2 + sweepFraud,
              sweep: sweepSafe,
            ),

            Container(
              width: 240,
              height: 240,
              margin: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF141414).withOpacity(0.92),
              ),
            ),

            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  totalText,
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    _LegendDot(color: Color(0xFFE74C3C)),
                    SizedBox(width: 6),
                    Text('Fraud', style: TextStyle(color: Colors.white70)),
                    SizedBox(width: 16),
                    _LegendDot(color: Color(0xFF4169E1)),
                    SizedBox(width: 6),
                    Text('Safe', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _arc({
    required Color color,
    required double start,
    required double sweep,
  }) {
    return CustomPaint(
      size: const Size(240, 240),
      painter: _ArcPainter(color: color, start: start, sweep: sweep),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter({required this.color, required this.start, required this.sweep});
  final Color color;
  final double start;
  final double sweep;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 30.0;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke;

    final inset = stroke / 2 + 2;
    final r = Rect.fromLTWH(
      inset,
      inset,
      size.width - inset * 2,
      size.height - inset * 2,
    );
    canvas.drawArc(r, start, sweep, false, paint);
  }

  @override
  bool shouldRepaint(covariant _ArcPainter old) =>
      old.color != color || old.start != start || old.sweep != sweep;
}
