import 'package:flutter/material.dart';
import 'product_item_widget.dart';
import '../../models/trip_destination.dart';

class ProductListWidget extends StatelessWidget {
  TripDestination destination;

  ProductListWidget(this.destination);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(destination.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            destination.description,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          SizedBox(height: 24),
          Text(
            '추천 상품',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ListView.builder(
            //자신의 컨텐츠 사이즈 정도만 화면을 차지한다..
            shrinkWrap: true,
            //ListView 는 자체 스크롤을 지원한다.. 하지마라..
            //화면 전체 스크롤에 따라라..
            physics: NeverScrollableScrollPhysics(),
            itemCount: destination.products.length, // 상품의 사이즈에 맞게 동적 설정
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: ProductItemWidget(index, destination),
              );
            },
          ),
        ],
      ),
    );
  }
}
