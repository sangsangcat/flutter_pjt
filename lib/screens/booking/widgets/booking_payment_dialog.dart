import 'package:flutter/material.dart';
import 'package:flutter_pjt/models/booking.dart';
import 'package:flutter_pjt/theme/app_theme.dart';

/// 예약 결제 다이얼로그: 실제 결제 전 확인용 임시 요약 화면.
class BookingPaymentDialog extends StatelessWidget {
  final Booking booking;
  final VoidCallback onConfirm;

  const BookingPaymentDialog({
    super.key,
    required this.booking,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('결제하기'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(booking.product.title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              booking.destinationName,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPaymentRow('상품 금액', booking.product.price, theme),
                  const SizedBox(height: 8),
                  _buildPaymentRow('결제 수단', '신용카드', theme),
                  const SizedBox(height: 8),
                  _buildPaymentRow('결제 상태', '즉시 승인', theme),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '실제 결제 연동 전 임시 화면입니다. 확인을 누르면 예약 상태가 결제 완료로 변경됩니다.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: AppTheme.compactPrimaryButtonStyle(),
          child: const Text('결제 진행'),
        ),
      ],
    );
  }

  Widget _buildPaymentRow(String label, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
