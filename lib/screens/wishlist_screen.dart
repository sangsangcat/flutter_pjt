import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/trip_provider.dart';
import 'detail/product_detail_dialog.dart'; // 추가

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('관심 상품'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Consumer2<WishlistProvider, TripProvider>(
        builder: (context, wishlistProvider, tripProvider, child) {
          final wishlistKeys = wishlistProvider.wishlistProductKeys;

          if (wishlistKeys.isEmpty) {
            return const Center(child: Text('관심 상품이 없습니다.'));
          }

          // 찜한 상품 키 리스트를 바탕으로 실제 상품 정보 찾기
          // 키 형식: "destinationId_productTitle"
          return ListView.builder(
            itemCount: wishlistKeys.length,
            itemBuilder: (context, index) {
              final key = wishlistKeys[index];
              final parts = key.split('_');
              final destId = int.tryParse(parts[0]);
              final productTitle = parts.length > 1 ? parts[1] : '';

              if (destId == null) return const SizedBox.shrink();

              // TripProvider에서 해당 여행지 찾기
              final destination = tripProvider.filteredDestinations.firstWhere(
                (d) => d.id == destId,
                orElse: () => tripProvider.filteredDestinations.firstWhere(
                  (d) => d.id == destId,
                ),
              );

              // 해당 여행지에서 상품 찾기
              final product = destination.products.firstWhere(
                (p) => p.title.replaceAll(' ', '') == productTitle,
              );

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      destination.imagePath,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(product.title),
                  subtitle: Text('${destination.name} / ${product.price}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
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
