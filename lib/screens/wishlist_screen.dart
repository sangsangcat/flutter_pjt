import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart'; // [추가]
import '../providers/wishlist_provider.dart';
import '../providers/trip_provider.dart';
import 'detail/product_detail_dialog.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('관심 상품')),
      body: Consumer2<WishlistProvider, TripProvider>(
        builder: (context, wishlistProvider, tripProvider, child) {
          final wishlistKeys = wishlistProvider.wishlistProductKeys;

          if (wishlistKeys.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: theme.colorScheme.tertiary.withValues(alpha: 0.35),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '관심 상품이 없습니다.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          // 찜한 상품 키 리스트를 바탕으로 실제 상품 정보 찾기
          // 키 형식: "destinationId_productTitle"
          return ListView.builder(
            itemCount: wishlistKeys.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final key = wishlistKeys[index];
              final parts = key.split('_');
              final destId = int.tryParse(parts[0]);
              final productTitle = parts.length > 1 ? parts[1] : '';

              if (destId == null) return const SizedBox.shrink();

              // [수정] filteredDestinations 대신 tripProvider.allDestinations에서 검색하여 에러 방지
              final destination = tripProvider.getDestinationById(destId);

              // 여행지 정보를 찾지 못한 경우 안전하게 처리
              if (destination == null) return const SizedBox.shrink();

              // [수정] firstWhere 에러 방지를 위해 orElse 사용 및 안전한 검색
              final product = destination.products.firstWhere(
                (p) => p.title.replaceAll(' ', '') == productTitle,
                orElse: () => destination.products.first,
              );

              return Card(
                // [수정] AppTheme의 CardTheme 설정을 따르도록 하여 톤 일치 및 일관성 확보
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    // [수정] Image.network를 CachedNetworkImage로 교체
                    child: CachedNetworkImage(
                      imageUrl: destination.imagePath,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 60,
                        height: 60,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 60,
                        height: 60,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.error_outline),
                      ),
                    ),
                  ),
                  title: Text(
                    product.title,
                    style: theme.textTheme.titleMedium,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${destination.name} / ${product.price}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: theme.colorScheme.tertiary,
                    ),
                    onPressed: () {
                      wishlistProvider.toggleWish(destination.id, product);
                    },
                  ),
                  onTap: () {
                    // [수정] 상세 페이지 이동 대신 다이얼로그 출력
                    showDialog(
                      context: context,
                      builder: (context) => ProductDetailDialog(
                        destination: destination,
                        product: product,
                        imagePath: destination.imagePath,
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
