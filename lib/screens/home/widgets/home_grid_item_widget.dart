import 'package:flutter/material.dart';
import 'package:flutter_pjt/screens/common/app_network_image.dart';
import '../../../models/trip_destination.dart';

// 여행 상품 하나를 보여주는 아이템 위젯
class HomeGridItem extends StatelessWidget {
  final TripDestination destination;

  const HomeGridItem({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      // Grid 안에서는 CardTheme의 기본 margin이 카드 사이 간격을 과하게 키우므로 Grid 간격만 사용
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            // 카드와 이미지의 곡률을 맞춰 AppTheme.cardTheme의 형태가 깨져 보이지 않게 함
            child: AppNetworkImage(
              imageUrl: destination.imagePath,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              fallbackIcon: Icons.image_not_supported_outlined,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                // [수정] 브랜드 세컨더리 컬러(Pink)를 활용하여 할인 정보 강조
                Text(
                  destination.discount,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
