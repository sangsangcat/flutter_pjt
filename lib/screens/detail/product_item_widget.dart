import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart'; // [추가] 이미지 캐싱
import '../../models/trip_destination.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/user_provider.dart';
import 'product_detail_dialog.dart';

class ProductItemWidget extends StatelessWidget {
  final TripDestination destination;
  final int index;

  const ProductItemWidget(this.index, this.destination, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 해당 인덱스에 맞는 실제 상품 데이터 가져오기
    final product = destination.products.length > index
        ? destination.products[index]
        : null;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        // [수정] 직접 CachedNetworkImage를 사용하여 로딩 UI 제어 강화
        child: CachedNetworkImage(
          imageUrl: destination.imagePath,
          width: 64,
          height: 64,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 64,
            height: 64,
            color: theme.colorScheme.surfaceContainerHighest,
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: 64,
            height: 64,
            color: theme.colorScheme.surfaceContainerHighest,
            child: const Icon(Icons.error_outline, size: 20),
          ),
        ),
      ),
      title: Text(
        product?.title ?? '${destination.name} 여행 상품 ${index + 1}',
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          product != null ? '${product.price}부터' : '가격 정보 준비 중',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // 선택된 하트에만 테마의 핑크 포인트를 사용해 과한 강조를 피함
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (product != null)
            Consumer<WishlistProvider>(
              builder: (context, wishlist, child) {
                final isWished = wishlist.isWished(destination.id, product);
                return IconButton(
                  icon: Icon(
                    isWished ? Icons.favorite : Icons.favorite_border,
                    color: isWished
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                  onPressed: () =>
                      _handleWishlistToggle(context, wishlist, product),
                );
              },
            ),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ],
      ),
      onTap: () {
        // 상품 데이터가 존재하는 경우에만 다이얼로그 출력
        if (product != null) {
          showDialog(
            context: context,
            builder: (context) => ProductDetailDialog(
              destination: destination,
              product: product,
              imagePath: destination.imagePath,
            ),
          );
        }
      },
    );
  }

  /// 찜하기 토글 및 로그인 상태 확인 로직 유지
  void _handleWishlistToggle(
    BuildContext context,
    WishlistProvider wishlist,
    TravelProduct product,
  ) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (!userProvider.hasUserInfo) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('로그인이 필요한 서비스입니다.')));
      return;
    }
    wishlist.toggleWish(destination.id, product);
  }
}
