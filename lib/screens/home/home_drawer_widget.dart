import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pjt/providers/user_provider.dart';
import 'package:flutter_pjt/providers/wishlist_provider.dart';
import 'package:flutter_pjt/providers/booking_provider.dart';
import 'package:flutter_pjt/routes/app_routes.dart';
import 'package:provider/provider.dart';

class HomeDrawerWidget extends StatelessWidget {
  const HomeDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                decoration: const BoxDecoration(color: Colors.blue),
                child: SafeArea(
                  bottom: false, // 하단은 ListView와 이어지므로 상단만 적용
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 16,
                    ),
                    child: isLoggedIn
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 35,
                                // [핵심 변경] 프로필 이미지가 URL(구글)인지 파일 경로(로컬)인지 판단하여 처리
                                backgroundImage:
                                    userInfo?.profileImagePath != null
                                    ? (userInfo!.profileImagePath!.startsWith(
                                            'http',
                                          )
                                          ? NetworkImage(
                                              userInfo.profileImagePath!,
                                            )
                                          : FileImage(
                                                  File(
                                                    userInfo.profileImagePath!,
                                                  ),
                                                )
                                                as ImageProvider)
                                    : const AssetImage(
                                        'assets/images/user_basic.jpg',
                                      ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.myInfo,
                                  );
                                },
                                icon: const Icon(Icons.settings, size: 16),
                                label: const Text('계정 설정'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  minimumSize: const Size(0, 32),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                userInfo?.name ?? '사용자',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userInfo?.email ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
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
                                size: 60,
                                color: Colors.white54,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                '로그인이 필요합니다',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 16),
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
                                      foregroundColor: Colors.blue,
                                    ),
                                    child: const Text('로그인'),
                                  ),
                                  const SizedBox(width: 8),
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
                                        color: Colors.white,
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
          // 관심상품 메뉴
          Consumer<WishlistProvider>(
            builder: (context, wishlist, child) {
              return ListTile(
                leading: Badge(
                  label: Text('${wishlist.count}'),
                  isLabelVisible: wishlist.count > 0,
                  child: const Icon(Icons.favorite),
                ),
                title: const Text('관심상품'),
                onTap: () {
                  Navigator.pop(context); // Drawer 닫기
                  Navigator.pushNamed(
                    context,
                    AppRoutes.wishlist,
                  ); // 관심상품 화면으로 이동
                },
              );
            },
          ),
          // 예약 목록 메뉴
          Consumer<BookingProvider>(
            builder: (context, booking, child) {
              return ListTile(
                leading: Badge(
                  label: Text('${booking.count}'),
                  isLabelVisible: booking.count > 0,
                  child: const Icon(Icons.card_travel),
                ),
                title: const Text('예약 목록'),
                onTap: () {
                  Navigator.pop(context); // Drawer 닫기
                  Navigator.pushNamed(
                    context,
                    AppRoutes.booking,
                  ); // 예약 목록 화면으로 이동
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
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
