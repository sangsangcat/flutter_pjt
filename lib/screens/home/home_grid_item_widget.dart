import 'package:flutter/material.dart';
import '../../models/trip_destination.dart';

//여행 상품 하나.. Item
class HomeGridItem extends StatelessWidget {
  final TripDestination destination;

  const HomeGridItem({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              // 서버 주소(URL)를 사용하여 이미지를 불러오므로 Image.network를 사용해야 한다.
              child: Image.network(
                destination.imagePath,
                fit: BoxFit.cover,
                // 이미지 로딩 중 표시될 위젯
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                // 에러 발생 시 표시될 위젯
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.red);
                },
              ),
            ),
            Text(
              destination.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              destination.discount,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
