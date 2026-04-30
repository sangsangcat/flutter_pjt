import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pjt/screens/common/app_network_image.dart';
import 'package:flutter_pjt/theme/app_theme.dart';
import '../providers/booking_provider.dart';
import '../providers/user_provider.dart';
import '../providers/trip_provider.dart';
import '../services/firestore_service.dart';
import 'common/app_empty_state.dart';
import 'detail/product_detail_dialog.dart';
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

              return Card(
                // [수정] AppTheme의 CardTheme 설정을 따르도록 하여 톤 일치 및 일관성 확보
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // [핵심] 상단 정보 영역만 클릭 가능하도록 InkWell 배치
                    InkWell(
                      onTap: () {
                        try {
                          // [수정] filteredDestinations 대신 allDestinations에서 검색하여 카테고리 필터 에러 방지
                          final destination = tripProvider.allDestinations
                              .firstWhere((d) => d.id == booking.destinationId);

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
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppNetworkImage(
                              imageUrl: booking.destinationImagePath,
                              width: 70,
                              height: 70,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          booking.product.title,
                                          style: theme.textTheme.titleMedium,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      _buildStatusChip(theme, booking.status),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    booking.destinationName,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '예약일: $dateStr',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (booking.status == 'pending') ...[
                            TextButton(
                              onPressed: () => _showCancelDialog(
                                context,
                                firestoreService,
                                userId!,
                                booking.id,
                              ),
                              style: AppTheme.dangerTextButtonStyle(),
                              child: const Text('예약 취소'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _handlePayment(
                                context,
                                firestoreService,
                                userId!,
                                booking.id,
                              ),
                              style: AppTheme.compactPrimaryButtonStyle(),
                              child: const Text('결제하기'),
                            ),
                          ] else if (booking.status == 'paid')
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 12,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 16,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '결제 완료',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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

  Widget _buildStatusChip(ThemeData theme, String status) {
    Color color;
    String label;
    switch (status) {
      case 'paid':
        color = AppTheme.successColor;
        label = '결제완료';
        break;
      case 'cancelled':
        color = AppTheme.dangerColor;
        label = '취소됨';
        break;
      default:
        color = AppTheme.warningColor;
        label = '대기중';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(color: color),
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
