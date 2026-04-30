// 관심상품 화면: 사용자가 찜한 여행 상품을 카드 리스트로 보여주는 화면.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pjt/screens/common/app_list_card.dart';
import 'package:flutter_pjt/screens/common/app_network_image.dart';
import 'package:flutter_pjt/providers/wishlist_provider.dart';
import 'package:flutter_pjt/providers/trip_provider.dart';
import 'package:flutter_pjt/screens/common/app_empty_state.dart';
import 'package:flutter_pjt/screens/detail/widgets/product_detail_dialog.dart';

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
            return AppEmptyState(
              icon: Icons.favorite_border,
              title: '관심 상품이 없습니다.',
              iconColor: theme.colorScheme.tertiary.withValues(alpha: 0.35),
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

              return AppListCard(
                leading: AppNetworkImage(
                  imageUrl: destination.imagePath,
                  width: 60,
                  height: 60,
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text(product.title, style: theme.textTheme.titleMedium),
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
                  icon: Icon(Icons.favorite, color: theme.colorScheme.tertiary),
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
              );
            },
          );
        },
      ),
    );
  }
}
