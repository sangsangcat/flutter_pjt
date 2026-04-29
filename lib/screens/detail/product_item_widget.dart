import 'package:flutter/material.dart';
import '../../models/trip_destination.dart';
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
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        // 상품 데이터가 존재하는 경우에만 다이얼로그 출력
        if (product != null) {
          showDialog(
            context: context,
            builder: (context) => ProductDetailDialog(
              product: product,
              imagePath: destination.imagePath,
            ),
          );
        } else {
          // 데이터가 없는 경우 안내 메시지 출력
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('상세 정보가 준비 중인 상품입니다.')));
        }
      },
    );
  }
}
