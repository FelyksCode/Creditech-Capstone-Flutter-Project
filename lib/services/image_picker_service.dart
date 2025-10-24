import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  /// Show bottom sheet with camera and gallery options
  static Future<File?> showImageSourceBottomSheet(BuildContext context) async {
    return showModalBottomSheet<File?>(
      context: context,
      backgroundColor: const Color(0xFF17191F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Profile Photo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ImageSourceOption(
                  icon: Icons.camera_alt_outlined,
                  label: 'Camera',
                  onTap: () async {
                    final file = await _pickImageFromCamera();
                    if (context.mounted) {
                      Navigator.pop(context, file);
                    }
                  },
                ),
                _ImageSourceOption(
                  icon: Icons.photo_library_outlined,
                  label: 'Gallery',
                  onTap: () async {
                    final file = await _pickImageFromGallery();
                    if (context.mounted) {
                      Navigator.pop(context, file);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Pick image from camera
  static Future<File?> _pickImageFromCamera() async {
    try {
      // Request camera permission
      final cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        return null;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (image != null) {
        final file = File(image.path);
        
        // Validate file exists
        if (await file.exists()) {
          return file;
        } else {
          return null;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Pick image from gallery
  static Future<File?> _pickImageFromGallery() async {
    try {
      PermissionStatus photoStatus = await Permission.photos.request();
      
      if (!photoStatus.isGranted) {
        PermissionStatus storageStatus = await Permission.storage.request();
        if (!storageStatus.isGranted) {
          print('Permissions not granted');
        }
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (image != null) {
        final file = File(image.path);
        
        // Validate file exists
        if (await file.exists()) {
          final fileSize = await file.length();
          return file;
        } else {
          return null;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Check if camera permission is available
  static Future<bool> isCameraPermissionGranted() async {
    return await Permission.camera.isGranted;
  }

  /// Check if photo/storage permission is available
  static Future<bool> isStoragePermissionGranted() async {
    try {
      final photoStatus = await Permission.photos.isGranted;
      final storageStatus = await Permission.storage.isGranted;
      return photoStatus || storageStatus;
    } catch (e) {
      return false;
    }
  }
}

class _ImageSourceOption extends StatelessWidget {
  const _ImageSourceOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2D36),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFF4169E1),
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}