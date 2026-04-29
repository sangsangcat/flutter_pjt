import 'package:flutter/material.dart';
import 'package:flutter_pjt/providers/user_provider.dart';
import 'package:flutter_pjt/screens/myinfo/myinfo_form_widget.dart';
import 'package:provider/provider.dart';
import 'myinfo/myinfo_empty_state_widget.dart';

class MyinfoScreen extends StatefulWidget {
  const MyinfoScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyInfoScreenState();
  }
}

class MyInfoScreenState extends State<MyinfoScreen> {
  bool showForm = false;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // [핵심] 유저 정보가 있으면 바로 수정 폼을 보여줌
    if (userProvider.userInfo != null) {
      showForm = true;
    }
  }

  void handleShowForm(bool shouldShow) {
    setState(() {
      showForm = shouldShow;
    });
  }

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
          // 로그인 여부에 따라 적절한 위젯 노출
          if (!userProvider.hasUserInfo && !showForm) {
            return MyinfoEmptyStateWidget(handleShowForm);
          } else {
            return const MyinfoFormWidget();
          }
        },
      ),
    );
  }
}
