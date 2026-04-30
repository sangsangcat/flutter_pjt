// 계정 설정 화면: 로그인 상태에 따라 계정 정보 폼을 보여주고, 비로그인 상태는 로그인 화면으로 보낸다.
import 'package:flutter/material.dart';
import 'package:flutter_pjt/providers/user_provider.dart';
import 'package:flutter_pjt/routes/app_routes.dart';
import 'package:provider/provider.dart';

import 'widgets/account_setting_form_widget.dart';

class AccountSettingScreen extends StatelessWidget {
  const AccountSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 타이틀을 '계정 설정'으로 변경
        title: const Text('계정 설정'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // 비로그인 상태는 이 화면에 머물게 하기보다 로그인 화면으로 보내는 편이 흐름이 더 자연스럽다.
          if (!userProvider.hasUserInfo) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            });
            return const SizedBox.shrink();
          }
          return const AccountSettingFormWidget();
        },
      ),
    );
  }
}
