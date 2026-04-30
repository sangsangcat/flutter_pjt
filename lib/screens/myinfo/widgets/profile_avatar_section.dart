import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// 프로필 이미지 섹션: 임시 선택 이미지, 서버 이미지, 카메라 액션을 묶는다.
class ProfileAvatarSection extends StatelessWidget {
  final String? tempLocalPath;
  final String? avatarPath;
  final bool isSaving;
  final VoidCallback onTapCamera;

  const ProfileAvatarSection({
    super.key,
    required this.tempLocalPath,
    required this.avatarPath,
    required this.isSaving,
    required this.onTapCamera,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 65,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            // 프로필 이미지는 상태에 따라 즉시 미리보기(File) 또는 서버 캐시를 보여준다.
            backgroundImage: tempLocalPath != null
                ? FileImage(File(tempLocalPath!)) as ImageProvider
                : (avatarPath != null
                      ? CachedNetworkImageProvider(avatarPath!)
                      : const AssetImage('assets/images/user_basic.jpg')
                            as ImageProvider),
            child: isSaving
                ? CircularProgressIndicator(color: theme.colorScheme.onSurface)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: theme.colorScheme.secondary,
              radius: 20,
              child: IconButton(
                onPressed: isSaving ? null : onTapCamera,
                icon: Icon(
                  Icons.camera_alt,
                  color: theme.colorScheme.onSecondary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
