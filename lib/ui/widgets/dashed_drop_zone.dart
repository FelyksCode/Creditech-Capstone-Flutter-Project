import 'package:flutter/material.dart';

class DashedDropZone extends StatelessWidget {
  const DashedDropZone({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: CustomPaint(
        painter: _DashedRRectPainter(
          color: Colors.white.withOpacity(0.85),
          radius: 14,
          strokeWidth: 1.4,
          dash: 6,
          gap: 5,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white.withOpacity(0.03),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  _DashedRRectPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
    required this.dash,
    required this.gap,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final next = (distance + dash).clamp(0.0, metric.length).toDouble();
        final extract = metric.extractPath(distance, next);
        canvas.drawPath(extract, p);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter old) =>
      color != old.color ||
      radius != old.radius ||
      strokeWidth != old.strokeWidth ||
      dash != old.dash ||
      gap != old.gap;
}