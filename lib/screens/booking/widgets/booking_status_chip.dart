import 'package:flutter/material.dart';
import 'package:flutter_pjt/theme/app_theme.dart';

/// 예약 상태 칩: pending, paid, cancel 같은 상태를 색으로 구분한다.
class BookingStatusChip extends StatelessWidget {
  final String status;

  const BookingStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
}
