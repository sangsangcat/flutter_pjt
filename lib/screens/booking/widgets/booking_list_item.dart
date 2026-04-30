import 'package:flutter/material.dart';
import 'package:flutter_pjt/models/booking.dart';
import 'package:flutter_pjt/screens/booking/widgets/booking_status_chip.dart';
import 'package:flutter_pjt/screens/common/app_network_image.dart';
import 'package:flutter_pjt/theme/app_theme.dart';

/// 예약 목록 카드: 이미지, 예약 정보, 상태/액션 버튼을 한 줄로 조립한다.
class BookingListItem extends StatelessWidget {
  final Booking booking;
  final String dateStr;
  final VoidCallback onOpenDetail;
  final VoidCallback onCancel;
  final VoidCallback onPayment;

  const BookingListItem({
    super.key,
    required this.booking,
    required this.dateStr,
    required this.onOpenDetail,
    required this.onCancel,
    required this.onPayment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onOpenDetail,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                booking.product.title,
                                style: theme.textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            BookingStatusChip(status: booking.status),
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
                        Text('예약일: $dateStr', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (booking.status == 'pending') ...[
                  TextButton(
                    onPressed: onCancel,
                    style: AppTheme.dangerTextButtonStyle(),
                    child: const Text('예약 취소'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: onPayment,
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
  }
}
