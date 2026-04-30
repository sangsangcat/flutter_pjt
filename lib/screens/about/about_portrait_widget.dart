import 'package:flutter/material.dart';
import 'build_feature_card.dart';

//세로방향 출력 위젯..
class AboutPortraitWidget extends StatelessWidget {
  const AboutPortraitWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              // [수정] 브랜드 컬러(Navy)의 연한 톤 적용
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
            ),
            child: Icon(
              Icons.travel_explore_outlined,
              size: 100,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Trip App',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '세계 여행을 계획하고 관리하는 최고의 앱',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 40),
          // [수정] buildFeatureCard 호출 시 context 전달 및 세련된 아이콘 적용
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
          const SizedBox(height: 40),
          Text('Version 1.0.0', style: theme.textTheme.bodySmall),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
