import 'package:flutter/material.dart';
import 'upload_file_item.dart';
import 'package:creditech_capstone_project/ui/widgets/dust_background.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const items = <UploadItemData>[
      UploadItemData(
        fileName: 'my-cv.pdf',
        sizeText: '60 KB of 120 KB',
        status: UploadStatus.uploading,
        progress: 0.55,
      ),
      UploadItemData(
        fileName: 'Google-certificate.pdf',
        sizeText: '94 KB of 94 KB',
        status: UploadStatus.completed,
        progress: 1.0,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const Positioned.fill(
            child: DustBackground(
              assetPath: 'assets/images/img_1.png',
              opacity: 0.06,
            ),
          ),

          // LAYER: konten utama
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  const Text(
                    'Analytics',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),

                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A3E53),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 24,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.cloud_upload_outlined, color: Colors.white70),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Upload files',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700)),
                                  SizedBox(height: 2),
                                  Text(
                                    'Select and upload the files oof your choice',
                                    style: TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const Padding(
                                padding: EdgeInsets.only(top: 4.0, left: 8),
                                child: Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        Container(height: 1, color: Colors.white.withOpacity(0.15)),
                        const SizedBox(height: 14),

                        _DashedDropZone(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.cloud_upload_outlined, size: 28, color: Colors.white70),
                              const SizedBox(height: 10),
                              const Text(
                                'Choose a file or drag & drop it here',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'JPEG, PNG, PDG, and MP4 formats, up to 50MB',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                              const SizedBox(height: 14),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(color: Colors.white.withOpacity(0.8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () {},
                                child: const Text('Browse File'),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        ...items.map((it) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: UploadFileItem(data: it),
                        )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1E8DE),
                        foregroundColor: const Color(0xFF1B1B1B),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Get Smart Insights',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedDropZone extends StatelessWidget {
  const _DashedDropZone({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
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