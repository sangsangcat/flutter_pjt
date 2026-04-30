// 예약 목록 화면: 예약 상태 확인, 취소, 결제 흐름을 관리하는 화면.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pjt/theme/app_theme.dart';
import 'package:flutter_pjt/models/booking.dart';
import 'package:flutter_pjt/providers/booking_provider.dart';
import 'package:flutter_pjt/providers/user_provider.dart';
import 'package:flutter_pjt/providers/trip_provider.dart';
import 'package:flutter_pjt/services/firestore_service.dart';
import 'package:flutter_pjt/screens/common/app_empty_state.dart';
import 'widgets/booking_list_item.dart';
import 'widgets/booking_payment_dialog.dart';
import 'package:flutter_pjt/screens/detail/widgets/product_detail_dialog.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firestoreService = FirestoreService();
    final userId = Provider.of<UserProvider>(context, listen: false).userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('예약 목록'),
        // [수정] AppTheme의 차분한 배경색이 자동으로 적용되도록 하드코딩 제거
      ),
      body: Consumer2<BookingProvider, TripProvider>(
        // Consumer2로 확장하여 여행 정보 참조
        builder: (context, bookingProvider, tripProvider, child) {
          final bookings = bookingProvider.bookings;

          if (bookings.isEmpty) {
            return AppEmptyState(
              icon: Icons.event_busy_outlined,
              title: '예약된 내역이 없습니다.',
              iconColor: theme.colorScheme.primary.withValues(alpha: 0.15),
            );
          }

          return ListView.builder(
            itemCount: bookings.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final dateStr = DateFormat(
                'yyyy-MM-dd HH:mm',
              ).format(booking.createdAt);

              return BookingListItem(
                booking: booking,
                dateStr: dateStr,
                onOpenDetail: () {
                  try {
                    final destination = tripProvider.allDestinations.firstWhere(
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
                onCancel: () => _showCancelDialog(
                  context,
                  firestoreService,
                  userId!,
                  booking.id,
                ),
                onPayment: () => _showPaymentDialog(
                  context,
                  firestoreService,
                  userId,
                  booking,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showPaymentDialog(
    BuildContext context,
    FirestoreService service,
    String? uid,
    Booking booking,
  ) {
    if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('로그인이 필요한 서비스입니다.')));
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => BookingPaymentDialog(
        booking: booking,
        onConfirm: () {
          Navigator.pop(dialogContext);
          _handlePayment(context, service, uid, booking.id);
        },
      ),
    );
  }

  void _showCancelDialog(
    BuildContext context,
    FirestoreService service,
    String uid,
    String bookingId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('예약 취소'),
        content: const Text('정말로 예약을 취소하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () async {
              await service.deleteBooking(uid, bookingId);
              if (context.mounted) Navigator.pop(context);
            },
            style: AppTheme.dangerTextButtonStyle(),
            child: const Text('예, 취소합니다'),
          ),
        ],
      ),
    );
  }

  void _handlePayment(
    BuildContext context,
    FirestoreService service,
    String uid,
    String bookingId,
  ) async {
    // 가상 결제 프로세스
    await service.updateBookingStatus(uid, bookingId, 'paid');
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('결제가 완료되었습니다.')));
    }
  }
}
