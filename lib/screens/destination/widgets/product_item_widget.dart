import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pjt/screens/common/app_list_card.dart';
import 'package:flutter_pjt/screens/common/app_network_image.dart';
import '../../../models/trip_destination.dart';
import '../../../providers/wishlist_provider.dart';
import 'product_detail_dialog.dart';

class ProductItemWidget extends StatelessWidget {
  final TripDestination destination;
  final int index;
  final EdgeInsetsGeometry? margin;

  const ProductItemWidget(
    this.index,
    this.destination, {
    super.key,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 해당 인덱스에 맞는 실제 상품 데이터 가져오기
    final product = destination.products.length > index
        ? destination.products[index]
        : null;

    return AppListCard(
      margin: margin,
      leading: AppNetworkImage(
        imageUrl: destination.imagePath,
        width: 64,
        height: 64,
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
                        : theme.colorScheme.onSurface.withValues(alpha: 0.28),
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

  /// 찜하기 토글은 Provider가 처리하고, UI는 결과만 반응한다.
  Future<void> _handleWishlistToggle(
    BuildContext context,
    WishlistProvider wishlist,
    TravelProduct product,
  ) async {
    final didToggle = await wishlist.toggleWish(destination.id, product);
    if (!context.mounted || didToggle) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('로그인이 필요한 서비스입니다.')));
  }
}
