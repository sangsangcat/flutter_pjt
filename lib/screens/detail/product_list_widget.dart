import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // [추가] 로딩 UX 개선
import 'product_item_widget.dart';
import '../../models/trip_destination.dart';

class ProductListWidget extends StatelessWidget {
  final TripDestination destination;

  const ProductListWidget(this.destination, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // [수정] CachedNetworkImage를 사용하여 로딩 Placeholder 및 에러 처리 추가
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: destination.imagePath,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 220,
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              errorWidget: (context, url, error) => Container(
                height: 220,
                color: theme.colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.error_outline),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            destination.description,
            style: theme.textTheme.bodyLarge, // 테마 스타일 적용
          ),
          const SizedBox(height: 32),
          Text(
            '추천 상품',
            style: theme.textTheme.titleLarge, // 테마 스타일 적용
          ),
          const SizedBox(height: 16),
          ListView.builder(
            //자신의 컨텐츠 사이즈 정도만 화면을 차지한다..
            shrinkWrap: true,
            //ListView 는 자체 스크롤을 지원한다.. 하지마라..
            //화면 전체 스크롤에 따라라..
            physics: const NeverScrollableScrollPhysics(),
            itemCount: destination.products.length, // 상품의 사이즈에 맞게 동적 설정
            itemBuilder: (context, index) {
              return Card(
                // [수정] AppTheme의 CardTheme을 따르도록 하드코딩된 마진 재조정
                margin: const EdgeInsets.only(bottom: 16),
                child: ProductItemWidget(index, destination),
              );
            },
          ),
        ],
      ),
    );
  }
}
