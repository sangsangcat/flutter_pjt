import 'package:flutter/material.dart';
import 'package:flutter_pjt/screens/common/app_empty_state.dart';
import 'package:flutter_pjt/theme/app_theme.dart';

class MyinfoEmptyStateWidget extends StatelessWidget {
  //상위 위젯의 함수.. 생성자 매개변수로 받아서.. 이벤트 발생시에 호출..
  final Function(bool) showForm;

  const MyinfoEmptyStateWidget(this.showForm, {super.key}); // super.key 추가

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.person_outline,
      title: '사용자 정보가 없습니다.',
      action: ElevatedButton(
        onPressed: () {
          //상위 함수 호출해서.. 상위에 의해 화면이 바뀌게..
          showForm(true);
        },
        style: AppTheme.compactPrimaryButtonStyle(),
        child: const Text('정보 입력하기'),
      ),
    );
  }
}
