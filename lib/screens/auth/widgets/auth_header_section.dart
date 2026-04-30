import 'package:flutter/material.dart';

/// 인증 화면 상단 영역: 아이콘, 큰 제목, 보조 문구를 한 덩어리로 보여준다.
class AuthHeaderSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const AuthHeaderSection({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 20),
        Icon(icon, size: 80, color: theme.colorScheme.primary),
        const SizedBox(height: 24),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
