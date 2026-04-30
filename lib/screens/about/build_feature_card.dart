import 'package:flutter/material.dart';

//함수의 매개변수를 이용해 카드 모양의 정보 위젯을 리턴하는 함수..
Widget buildFeatureCard({
  required IconData icon,
  required String title,
  required String description,
  required BuildContext context, // [추가] 테마 정보 활용을 위해 context 전달 받음
}) {
  final theme = Theme.of(context);

  return Card(
    // [수정] AppTheme의 CardTheme 설정을 따르도록 하드코딩 제거
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // [수정] 브랜드 컬러(Navy) 적용
          Icon(icon, size: 40, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium, // 테마 스타일 적용
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall, // 테마 스타일 적용
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
