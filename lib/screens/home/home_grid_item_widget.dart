import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/trip_destination.dart';

// 여행 상품 하나를 보여주는 아이템 위젯
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                // [수정] Coil과 유사한 cached_network_image 사용
                // 자동으로 디스크에 이미지를 캐싱하여 재실행 시 로딩 바가 나타나지 않음
                child: CachedNetworkImage(
                  imageUrl: destination.imagePath,
                  fit: BoxFit.cover,
                  // 캐시된 이미지가 없을 때(처음 로딩 시)만 보여줄 위젯
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  // 에러 시 보여줄 위젯
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              destination.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              destination.discount,
              style: const TextStyle(
                fontSize: 12, 
                color: Colors.blueAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
