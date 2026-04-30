import 'package:flutter/material.dart';
import 'package:flutter_pjt/screens/common/app_network_image.dart';
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
          // 공통 이미지 위젯을 사용해 상세/목록 화면의 로딩 UX를 같은 기준으로 유지
          AppNetworkImage(
            imageUrl: destination.imagePath,
            height: 220,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16),
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
              return ProductItemWidget(
                index,
                destination,
                // 목록 내부 카드는 아래 간격만 적용해 CardTheme 기본 margin과 중복되지 않게 함
                margin: const EdgeInsets.only(bottom: 16),
              );
            },
          ),
        ],
      ),
    );
  }
}
