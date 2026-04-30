// Drawer 본문: 로그인 상태에 따라 헤더와 메뉴 배지를 조합하는 내비게이션 패널.
import 'package:flutter/material.dart';
import 'package:flutter_pjt/providers/booking_provider.dart';
import 'package:flutter_pjt/providers/user_provider.dart';
import 'package:flutter_pjt/providers/wishlist_provider.dart';
import 'package:flutter_pjt/routes/app_routes.dart';
import 'package:provider/provider.dart';

import 'drawer_badge_icon.dart';
import 'home_drawer_header.dart';

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
              final bool isLoggedIn = userProvider.hasUserInfo;
              final userInfo = userProvider.userInfo;
              final avatarPath = userInfo?.profileImagePath;
              final displayName = userInfo?.name ?? '사용자';
              final displayEmail = userInfo?.email ?? '';

              return HomeDrawerHeader(
                isLoggedIn: isLoggedIn,
                avatarPath: avatarPath,
                displayName: displayName,
                displayEmail: displayEmail,
              );
            },
          ),
          const SizedBox(height: 8),
          // 관심상품 메뉴
          Consumer<WishlistProvider>(
            builder: (context, wishlist, child) {
              return ListTile(
                leading: DrawerBadgeIcon(
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
                leading: DrawerBadgeIcon(
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
