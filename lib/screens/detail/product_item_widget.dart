import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    // 해당 인덱스에 맞는 실제 상품 데이터 가져오기
    final product = destination.products.length > index
        ? destination.products[index]
        : null;

    return ListTile(
      leading: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(destination.imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(product?.title ?? '${destination.name} 여행 상품 ${index + 1}'),
      subtitle: Text(product != null ? '${product.price}부터' : '가격 정보 준비 중'),
      // [수정] 우측 영역에 하트 버튼(찜)과 이동 아이콘 배치
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
                    color: isWished ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => _handleWishlistToggle(context, wishlist, product),
                );
              },
            ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
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

  /// 찜하기 토글 및 로그인 상태 확인
  void _handleWishlistToggle(BuildContext context, WishlistProvider wishlist, TravelProduct product) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (!userProvider.hasUserInfo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요한 서비스입니다.')),
      );
      return;
    }
    wishlist.toggleWish(destination.id, product);
  }
}
