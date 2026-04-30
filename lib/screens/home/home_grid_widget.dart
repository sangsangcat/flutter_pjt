import 'package:flutter/material.dart';
import 'package:flutter_pjt/routes/app_routes.dart';
import '../../models/trip_destination.dart';
import 'home_grid_item_widget.dart';

class HomeGridWidget extends StatelessWidget {
  final List<TripDestination> destinations;

  const HomeGridWidget(this.destinations, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (destinations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // [수정] 브랜드 컬러를 적용하여 더 세련되고 감성적인 빈 상태 UI 구성
            Icon(
              Icons.map_outlined,
              size: 80,
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            Text(
              '해당 카테고리에 등록된 여행지가 없습니다.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12, // 카드 사이가 과하게 벌어지지 않도록 간격 축소
        mainAxisSpacing: 12,
        childAspectRatio: 0.85, // [수정] 카드 높이 비율을 텍스트 영역에 맞춰 최적화
      ),
      itemCount: destinations.length,
      itemBuilder: (context, index) {
        final destination = destinations[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.detail,
              arguments: destination,
            );
          },
          child: HomeGridItem(destination: destination),
        );
      },
    );
  }
}
