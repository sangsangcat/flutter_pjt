import 'package:flutter/material.dart';

/// 인증 화면 하단 영역: 로그인/회원가입처럼 서로 이동하는 링크를 묶는다.
class AuthFooterRow extends StatelessWidget {
  final String prompt;
  final String actionLabel;
  final VoidCallback onActionTap;

  const AuthFooterRow({
    super.key,
    required this.prompt,
    required this.actionLabel,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          prompt,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        TextButton(onPressed: onActionTap, child: Text(actionLabel)),
      ],
    );
  }
}
