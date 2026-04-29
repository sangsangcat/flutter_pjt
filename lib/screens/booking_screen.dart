import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import '../providers/user_provider.dart';
import '../providers/trip_provider.dart'; // 추가됨
import '../services/firestore_service.dart';
import 'detail/product_detail_dialog.dart'; // 추가됨
import 'package:intl/intl.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();
    final userId = Provider.of<UserProvider>(context, listen: false).userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('예약 목록'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Consumer2<BookingProvider, TripProvider>( // Consumer2로 확장하여 여행 정보 참조
        builder: (context, bookingProvider, tripProvider, child) {
          final bookings = bookingProvider.bookings;

          if (bookings.isEmpty) {
            return const Center(
              child: Text('예약된 내역이 없습니다.'),
            );
          }

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final dateStr = DateFormat('yyyy-MM-dd HH:mm').format(booking.createdAt);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // [수정] 상단 정보 영역만 클릭 가능하도록 InkWell 배치
                    InkWell(
                      onTap: () {
                        try {
                          final destination = tripProvider.filteredDestinations.firstWhere(
                            (d) => d.id == booking.destinationId,
                          );

                          showDialog(
                            context: context,
                            builder: (context) => ProductDetailDialog(
                              destination: destination,
                              product: booking.product,
                              imagePath: booking.destinationImagePath,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('상품 정보를 불러올 수 없습니다.')),
                          );
                        }
                      },
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)), // 카드 상단 라운드 유지
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              booking.destinationImagePath,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            booking.product.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(booking.destinationName),
                              Text('예약일: $dateStr'),
                            ],
                          ),
                          trailing: _buildStatusChip(booking.status),
                        ),
                      ),
                    ),
                    const Divider(height: 1), // 구분선 추가
                    // [수정] 하단 버튼 영역은 InkWell 외부에 배치
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (booking.status == 'pending') ...[
                            TextButton(
                              onPressed: () => _showCancelDialog(context, firestoreService, userId!, booking.id),
                              child: const Text('예약 취소', style: TextStyle(color: Colors.red)),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _handlePayment(context, firestoreService, userId!, booking.id),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('결제하기'),
                            ),
                          ] else if (booking.status == 'paid')
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                '결제 완료',
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    switch (status) {
      case 'paid':
        color = Colors.blue;
        label = '결제완료';
        break;
      case 'cancelled':
        color = Colors.red;
        label = '취소됨';
        break;
      default:
        color = Colors.orange;
        label = '대기중';
    }
    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  void _showCancelDialog(BuildContext context, FirestoreService service, String uid, String bookingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('예약 취소'),
        content: const Text('정말로 예약을 취소하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('아니오')),
          TextButton(
            onPressed: () async {
              await service.deleteBooking(uid, bookingId);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('예, 취소합니다', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handlePayment(BuildContext context, FirestoreService service, String uid, String bookingId) async {
    // 가상 결제 프로세스
    await service.updateBookingStatus(uid, bookingId, 'paid');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('결제가 완료되었습니다.')));
    }
  }
}
