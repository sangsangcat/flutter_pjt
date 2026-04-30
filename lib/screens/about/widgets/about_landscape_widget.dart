import 'package:flutter/material.dart';
import 'build_feature_card.dart';

//가로방향 출력 위젯..
class AboutLandscapeWidget extends StatelessWidget {
  const AboutLandscapeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // 왼쪽: 앱 로고 및 타이틀 섹션
        Expanded(
          flex: 1,
          child: Container(
            color: theme.colorScheme.primary.withValues(alpha: 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.travel_explore_outlined,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Trip App',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Version 1.0.0', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ),
        // 오른쪽: 주요 기능 목록 섹션
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                buildFeatureCard(
                  icon: Icons.flight_takeoff_outlined,
                  title: '항공편 예약',
                  description: '전세계 항공편을 쉽게 검색하고 예약하세요.',
                  context: context,
                ),
                const SizedBox(height: 12),
                buildFeatureCard(
                  icon: Icons.hotel_outlined,
                  title: '호텔 예약',
                  description: '최고의 호텔을 찾아 편안한 여행 즐기세요.',
                  context: context,
                ),
                const SizedBox(height: 12),
                buildFeatureCard(
                  icon: Icons.map_outlined,
                  title: '여행 가이드',
                  description: '현지 정보와 추천 명소를 확인하세요.',
                  context: context,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
