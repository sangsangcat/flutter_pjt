import 'package:flutter/material.dart';

class HomeTopWidget extends StatelessWidget {
  const HomeTopWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        // 메인 배경 이미지
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.asset(
            "assets/images/main_bg_1.jpg",
            fit: BoxFit.cover,
          ),
        ),
        // 이미지 위에 어두운 오버레이와 그라데이션을 추가하여 텍스트 가독성 확보
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // 이벤트 텍스트 섹션
        Container(
          height: 200, // 이미지 높이에 맞춰 조정
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬로 변경하여 세련미 강조
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '연말연시 특별 할인 이벤트',
                style: theme.textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 22, // 크기 미세 조정
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '최대 20% 할인',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
