import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pjt/screens/common/app_network_image.dart';
import 'package:flutter_pjt/theme/app_theme.dart';
import '../../../models/trip_destination.dart';
import '../../../providers/booking_provider.dart';
import '../../../providers/wishlist_provider.dart';

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
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      // DialogTheme을 사용해야 팝업도 AppTheme의 카드 톤/곡률을 함께 따라감
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 헤더: 타이틀과 닫기 버튼
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    product.title,
                    style: theme.textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
          // 메인 이미지 - 공통 이미지 위젯으로 다이얼로그와 상세 화면의 로딩 UX를 통일
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppNetworkImage(
              imageUrl: imagePath,
              width: double.infinity,
              height: 200,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          // 상세 정보 영역 (스크롤 가능)
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 정보 요약 박스: 테마의 inputFillColor와 톤을 일치시켜 부드럽게 표현
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.inputDecorationTheme.fillColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          theme,
                          Icons.calendar_today_outlined,
                          '일정',
                          '${product.date} (${product.duration})',
                        ),
                        _buildInfoRow(
                          theme,
                          Icons.payments_outlined,
                          '가격',
                          product.price,
                        ),
                        _buildInfoRow(
                          theme,
                          Icons.flight_outlined,
                          '항공',
                          product.airline,
                        ),
                        _buildInfoRow(
                          theme,
                          Icons.hotel_outlined,
                          '호텔',
                          product.hotel,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('상세 일정', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  // spread 문법이 Iterable을 바로 받을 수 있어 불필요한 리스트 생성을 피함
                  ...product.schedules.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${entry.key + 1}일차 : ',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          // 하단 버튼 영역: 찜하기 & 예약하기
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Row(
              children: [
                // 버튼 전체 색은 기본 테마를 따르고, 선택된 하트 아이콘만 핑크 포인트를 사용
                Expanded(
                  child: Consumer<WishlistProvider>(
                    builder: (context, wishlist, child) {
                      final isWished = wishlist.isWished(
                        destination.id,
                        product,
                      );
                      return OutlinedButton.icon(
                        onPressed: () =>
                            _handleWishlistToggle(context, wishlist),
                        style: AppTheme.compactOutlinedButtonStyle(),
                        icon: Icon(
                          isWished ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: isWished ? theme.colorScheme.tertiary : null,
                        ),
                        label: const Text('찜하기'),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // 오른쪽: 예약하기 버튼 - 브랜드 메인 컬러 적용
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleBooking(context),
                    child: const Text('예약하기'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 찜하기 토글은 Provider가 처리하고, UI는 결과만 반응한다.
  Future<void> _handleWishlistToggle(
    BuildContext context,
    WishlistProvider wishlist,
  ) async {
    final didToggle = await wishlist.toggleWish(destination.id, product);
    if (!context.mounted || didToggle) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('로그인이 필요한 서비스입니다.')));
  }

  /// 예약 처리 로직 유지
  void _handleBooking(BuildContext context) async {
    try {
      final created = await context.read<BookingProvider>().createPendingBooking(
        destination,
        product,
      );
      if (!context.mounted) return;

      if (created) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${product.title} 예약 완료!')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('로그인이 필요한 서비스입니다.')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('에러: $e')));
      }
    }
  }

  Widget _buildInfoRow(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: theme.colorScheme.primary.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 12),
          Text(
            '$label : ',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
