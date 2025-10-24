import 'dart:io';

enum UploadStatus { uploading, completed, failed }

class UploadFileStatus {
  final File file;
  final String fileName;
  final UploadStatus status;
  final double progress;

  UploadFileStatus({
    required this.file,
    required this.fileName,
    required this.status,
    required this.progress,
  });

  UploadFileStatus copyWith({
    File? file,
    String? fileName,
    UploadStatus? status,
    double? progress,
  }) {
    return UploadFileStatus(
      file: file ?? this.file,
      fileName: fileName ?? this.fileName,
      status: status ?? this.status,
      progress: progress ?? this.progress,
    );
  }
}

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