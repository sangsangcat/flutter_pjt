import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart'; // [추가]
import '../../models/trip_destination.dart';
import '../../models/booking.dart';
import '../../providers/booking_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/wishlist_provider.dart';

class ProductDetailDialog extends StatelessWidget {
  final TripDestination destination; // 추가: 여행지 전체 정보 (예약 시 필요)
  final TravelProduct product;
  final String imagePath;

  const ProductDetailDialog({
    super.key,
    required this.destination,
    required this.product,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 헤더: 타이틀과 닫기 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          // 메인 이미지 - [수정] CachedNetworkImage 적용
          CachedNetworkImage(
            imageUrl: imagePath,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: 200,
              color: Colors.grey[200],
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              height: 200,
              color: Colors.grey[200],
              child: const Icon(Icons.error, color: Colors.red),
            ),
          ),
          // 상세 정보 영역 (스크롤 가능)
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.calendar_today, '일정', '${product.date} (${product.duration})'),
                        _buildInfoRow(Icons.attach_money, '가격', product.price),
                        _buildInfoRow(Icons.airplanemode_active, '항공', product.airline),
                        _buildInfoRow(Icons.hotel, '호텔', product.hotel),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('상세 일정', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ...product.schedules.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${entry.key + 1}일차 : ', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(child: Text(entry.value)),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          // 하단 버튼 영역: 찜하기 & 예약하기
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // 왼쪽: 찜하기 버튼
                Expanded(
                  child: Consumer<WishlistProvider>(
                    builder: (context, wishlist, child) {
                      final isWished = wishlist.isWished(destination.id, product);
                      return OutlinedButton.icon(
                        onPressed: () => _handleWishlistToggle(context, wishlist),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 50),
                          side: BorderSide(color: isWished ? Colors.red : Colors.grey),
                          foregroundColor: isWished ? Colors.red : Colors.grey[700],
                        ),
                        icon: Icon(isWished ? Icons.favorite : Icons.favorite_border),
                        label: const Text('찜하기'),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // 오른쪽: 예약하기 버튼
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleBooking(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 50),
                    ),
                    child: const Text('예약하기', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 찜하기 토글 로직
  void _handleWishlistToggle(BuildContext context, WishlistProvider wishlist) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (!userProvider.hasUserInfo) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('로그인이 필요한 서비스입니다.')));
      return;
    }
    wishlist.toggleWish(destination.id, product);
  }

  /// 예약 처리 로직
  void _handleBooking(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // 1. 로그인 여부 확인
    if (!userProvider.hasUserInfo) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('로그인이 필요한 서비스입니다.')));
      return;
    }

    // 2. 예약 데이터 생성
    final newBooking = Booking(
      id: '',
      destinationId: destination.id,
      destinationName: destination.name,
      destinationImagePath: destination.imagePath,
      product: product,
      status: 'pending', // 초기 상태는 대기
      createdAt: DateTime.now(),
    );

    try {
      // 3. Provider를 통해 Firestore에 저장
      await Provider.of<BookingProvider>(context, listen: false).addBooking(newBooking);
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.title} 예약 완료!')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('에러: $e')));
      }
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          const SizedBox(width: 8),
          Text('$label : ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
