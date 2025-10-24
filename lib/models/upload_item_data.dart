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