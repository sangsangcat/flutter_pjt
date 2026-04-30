import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_pjt/providers/user_provider.dart';
import 'package:flutter_pjt/providers/wishlist_provider.dart';
import 'package:flutter_pjt/providers/booking_provider.dart';
import 'package:flutter_pjt/routes/app_routes.dart';
import 'package:provider/provider.dart';

class HomeDrawerWidget extends StatelessWidget {
  const HomeDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // [추가] 테마 정보 활용

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              // [핵심 변경] 로그인 여부에 따라 다른 헤더 UI를 노출
              final bool isLoggedIn = userProvider.hasUserInfo;
              final userInfo = userProvider.userInfo;

              return Container(
                width: double.infinity,
                // [수정] 브랜드 컬러(Navy)를 헤더 배경으로 적용
                decoration: BoxDecoration(color: theme.colorScheme.primary),
                child: SafeArea(
                  bottom: false, // 하단은 ListView와 이어지므로 상단만 적용
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 32, // 여백을 소폭 늘려 쾌적하게 조정
                      horizontal: 20,
                    ),
                    child: isLoggedIn
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // [수정] 분기 로직 제거 및 캐싱 적용 유지
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    userInfo?.profileImagePath != null
                                    ? CachedNetworkImageProvider(
                                        userInfo!.profileImagePath!,
                                      )
                                    : const AssetImage(
                                            'assets/images/user_basic.jpg',
                                          )
                                          as ImageProvider,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.myInfo,
                                  );
                                },
                                icon: const Icon(Icons.settings, size: 14),
                                label: const Text('계정 설정'),
                                style: ElevatedButton.styleFrom(
                                  // 브랜드 컬러 위에서 돋보이도록 투명도 있는 화이트 스타일
                                  backgroundColor: Colors.white.withValues(
                                    alpha: 0.15,
                                  ),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  minimumSize: const Size(0, 36),
                                  side: const BorderSide(color: Colors.white24),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                userInfo?.name ?? '사용자',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userInfo?.email ?? '',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.account_circle,
                                size: 70,
                                color: Colors.white38,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '로그인이 필요합니다',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.login,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor:
                                          theme.colorScheme.primary,
                                      elevation: 0,
                                    ),
                                    child: const Text('로그인'),
                                  ),
                                  const SizedBox(width: 12),
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.signup,
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Colors.white54,
                                      ),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('회원가입'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          // 관심상품 메뉴
          Consumer<WishlistProvider>(
            builder: (context, wishlist, child) {
              return ListTile(
                leading: _DrawerBadgeIcon(
                  icon: Icons.favorite_border,
                  count: wishlist.count,
                  iconColor: theme.colorScheme.primary,
                ),
                title: Text('관심상품', style: theme.textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(context); // Drawer 닫기
                  Navigator.pushNamed(context, AppRoutes.wishlist);
                },
              );
            },
          ),
          // 예약 목록 메뉴
          Consumer<BookingProvider>(
            builder: (context, booking, child) {
              return ListTile(
                leading: _DrawerBadgeIcon(
                  icon: Icons.card_travel,
                  count: booking.count,
                  iconColor: theme.colorScheme.primary,
                ),
                title: Text('예약 목록', style: theme.textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.booking);
                },
              );
            },
          ),
          const Divider(indent: 16, endIndent: 16),
          ListTile(
            leading: Icon(Icons.info_outline, color: theme.colorScheme.primary),
            title: Text('About', style: theme.textTheme.bodyLarge),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.about);
            },
          ),
        ],
      ),
    );
  }
}

class _DrawerBadgeIcon extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color iconColor;

  const _DrawerBadgeIcon({
    required this.icon,
    required this.count,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor),
          ),
          if (count > 0)
            // 배지를 아이콘 바깥 오른쪽 하단으로 빼서 아이콘 형태가 가려지지 않게 함
            Positioned(
              right: -4,
              bottom: -2,
              child: Badge(label: Text('$count')),
            ),
        ],
      ),
    );
  }
}
