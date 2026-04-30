import 'package:flutter/material.dart';
import 'package:flutter_pjt/theme/app_theme.dart';

/// 회원 탈퇴 확인 다이얼로그: 비밀번호 재인증 후 삭제 흐름을 시작한다.
class DeleteAccountDialog extends StatelessWidget {
  final bool isGoogleUser;
  final TextEditingController passwordController;
  final Future<void> Function(String? password) onConfirm;

  const DeleteAccountDialog({
    super.key,
    required this.isGoogleUser,
    required this.passwordController,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('회원 탈퇴'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('정말로 탈퇴하시겠습니까? 모든 정보가 삭제됩니다.'),
          if (!isGoogleUser) ...[
            const SizedBox(height: 16),
            Text(
              '본인 확인을 위해 비밀번호를 입력해 주세요.',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '비밀번호'),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await onConfirm(
              isGoogleUser ? null : passwordController.text.trim(),
            );
          },
          style: AppTheme.dangerTextButtonStyle(),
          child: const Text('탈퇴'),
        ),
      ],
    );
  }
}
