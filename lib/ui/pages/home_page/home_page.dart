import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'glassy_card.dart';
import 'package:creditech_capstone_project/ui/widgets/dust_background.dart';
import 'package:creditech_capstone_project/controller/profile_provider.dart';
import 'package:creditech_capstone_project/controller/chart_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Refresh the chart data when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChartProvider>(context, listen: false).refreshData();
    });
  }

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 18,
                ),
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

                    Consumer<ChartProvider>(
                      builder: (context, chartProvider, _) {
                        if (chartProvider.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white70,
                              ),
                            ),
                          );
                        }
                        if (chartProvider.thisMonthPredictions == null) {
                          return const Center(
                            child: Text(
                              'Error loading statistics',
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        }
                        if (chartProvider.thisMonthPredictions!.isEmpty) {
                          return const Center(
                            child: Text(
                              'No transactions this month',
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        }
                        return _Chart(
                          fraudRatio: chartProvider.fraudRatio,
                          totalText: chartProvider.totalCount.toString(),
                        );
                      },
                    ),
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
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good evening,',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 2),
            Text(
              profileProvider.nickName.isNotEmpty
                  ? profileProvider.nickName
                  : profileProvider.fullName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart({required this.fraudRatio, required this.totalText});

  final double fraudRatio;
  final String totalText;
  static const Color fraudColor = Color(0xFFE74C3C);
  static const Color safeColor = Color(0xFF4169E1);

  int get totalCount => int.parse(totalText);
  int get fraudCount => (totalCount * fraudRatio).round();
  int get safeCount => totalCount - fraudCount;

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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        Text(
                          '$safeCount',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: safeColor,
                          ),
                        ),
                        const Text(
                          'Safe',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      width: 1,
                      height: 30,
                      color: Colors.white24,
                    ),
                    Column(
                      children: [
                        Text(
                          '$fraudCount',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: fraudColor,
                          ),
                        ),
                        const Text(
                          'Fraud',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Total: $totalText',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
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
