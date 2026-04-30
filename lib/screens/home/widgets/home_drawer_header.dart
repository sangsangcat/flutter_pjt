import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pjt/routes/app_routes.dart';
import 'package:flutter_pjt/theme/app_theme.dart';

/// Drawer 상단 헤더: 로그인 상태에 따라 프로필 정보 또는 로그인 유도 UI를 보여준다.
class HomeDrawerHeader extends StatelessWidget {
  final bool isLoggedIn;
  final String? avatarPath;
  final String displayName;
  final String displayEmail;

  const HomeDrawerHeader({
    super.key,
    required this.isLoggedIn,
    required this.avatarPath,
    required this.displayName,
    required this.displayEmail,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: theme.colorScheme.primary),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
          child: isLoggedIn
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: theme.colorScheme.onPrimary,
                      backgroundImage: avatarPath != null
                          ? CachedNetworkImageProvider(avatarPath!)
                          : const AssetImage('assets/images/user_basic.jpg'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.myInfo);
                      },
                      icon: const Icon(Icons.settings, size: 12),
                      label: const Text('계정 설정'),
                      style: AppTheme.drawerHeaderActionButtonStyle(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      displayName,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displayEmail,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 70,
                      color: theme.colorScheme.onPrimary.withValues(
                        alpha: 0.38,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '로그인이 필요합니다',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, AppRoutes.login);
                          },
                          style: AppTheme.onPrimaryFilledButtonStyle(),
                          child: const Text('로그인'),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, AppRoutes.signup);
                          },
                          style: AppTheme.onPrimaryOutlinedButtonStyle(),
                          child: const Text('회원가입'),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
