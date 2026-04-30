// About 화면: 세로/가로 전환에 따라 소개 콘텐츠를 분기해서 보여주는 진입 화면.
import 'package:flutter/material.dart';
import 'package:flutter_pjt/routes/app_routes.dart';
import 'widgets/about_landscape_widget.dart';
import 'widgets/about_portrait_widget.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        // [수정] 하드코딩된 색상 제거하여 AppTheme 적용
        actions: [
          IconButton(
            onPressed: () {
              //home 화면으로 이동..
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              );
            },
            icon: const Icon(Icons.home_outlined),
          ),
        ],
      ),
      //화면 방향 감지해서.. 맞는 위젯을 출력.. 가로/세로 방향에 대응..
      //화면 회전이 발생하면 함수 자동 호출..
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return const AboutPortraitWidget();
          } else {
            return const AboutLandscapeWidget();
          }
        },
      ),
    );
  }
}
