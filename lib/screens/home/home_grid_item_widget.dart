import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/trip_destination.dart';

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
            child: ClipRRect(
              // 카드와 이미지의 곡률을 맞춰 AppTheme.cardTheme의 형태가 깨져 보이지 않게 함
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              // [수정] Coil과 유사한 cached_network_image 사용
              // 자동으로 디스크에 이미지를 캐싱하여 재실행 시 로딩 바가 나타나지 않음
              child: CachedNetworkImage(
                imageUrl: destination.imagePath,
                fit: BoxFit.cover,
                // [고도화] 로딩 시 브랜드 컬러 배경을 노출하여 시각적 안정감 부여
                placeholder: (context, url) => Container(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                ),
                // 에러 시 보여줄 위젯
                errorWidget: (context, url, error) => Container(
                  color: theme.colorScheme.errorContainer.withValues(
                    alpha: 0.1,
                  ),
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: theme.colorScheme.error.withValues(alpha: 0.5),
                  ),
                ),
              ),
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
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 15),
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
