import 'package:flutter/material.dart';

/// 프로필 이미지 선택 다이얼로그: 카메라와 갤러리 선택만 제공한다.
class ImagePickerDialog extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  const ImagePickerDialog({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('프로필 사진 선택'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('카메라로 촬영'),
            onTap: onCameraTap,
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('갤러리에서 선택'),
            onTap: onGalleryTap,
          ),
        ],
      ),
    );
  }
}
