import 'package:flutter/material.dart';

enum UploadStatus { uploading, completed, failed }

class UploadItemData {
  final String fileName;
  final String sizeText;
  final UploadStatus status;
  final double progress;

  const UploadItemData({
    required this.fileName,
    required this.sizeText,
    required this.status,
    required this.progress,
  });
}

class UploadFileItem extends StatelessWidget {
  const UploadFileItem({super.key, required this.data});
  final UploadItemData data;

  @override
  Widget build(BuildContext context) {
    final isUploading = data.status == UploadStatus.uploading;
    final isCompleted = data.status == UploadStatus.completed;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 10, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _FileBadge(),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.fileName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1B1B1B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            data.sizeText,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                          if (isUploading) ...[
                            const SizedBox(width: 6),
                            const SizedBox(
                              width: 12, height: 12,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(width: 4),
                            Text('Uploading...',
                                style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                          ],
                          if (isCompleted) ...[
                            const SizedBox(width: 8),
                            const _Dot(color: Color(0xFF2ECC71)),
                            const SizedBox(width: 4),
                            const Text(
                              'Completed',
                              style: TextStyle(
                                color: Color(0xFF2ECC71),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (isUploading)
                  _IconTap(icon: Icons.close_rounded)
                else if (isCompleted)
                  _IconTap(icon: Icons.delete_outline),
              ],
            ),

            if (isUploading) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: data.progress.clamp(0, 1),
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF4169E1)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


class _FileBadge extends StatelessWidget {
  const _FileBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(Icons.insert_drive_file_outlined, color: Color(0xFF8D95A6)),
          ),
          Positioned(
            left: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE74C3C),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'PDF',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconTap extends StatelessWidget {
  const _IconTap({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(top: 2.0, left: 4, right: 4),
        child: Icon(icon, color: Colors.grey.shade700, size: 20),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}