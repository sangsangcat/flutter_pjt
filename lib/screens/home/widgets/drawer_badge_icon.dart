import 'package:flutter/material.dart';

/// Drawer 메뉴 아이콘과 숫자 배지를 함께 보여주는 상태 표시 위젯.
class DrawerBadgeIcon extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color iconColor;

  const DrawerBadgeIcon({
    super.key,
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
