import 'package:flutter/material.dart';

class MyinfoEmptyStateWidget extends StatelessWidget {
  //상위 위젯의 함수.. 생성자 매개변수로 받아서.. 이벤트 발생시에 호출..
  final Function(bool) showForm;

  const MyinfoEmptyStateWidget(this.showForm, {super.key}); // super.key 추가

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // [수정] 브랜드 컬러와 테마 스타일 적용으로 시각적 완성도 향상
            Icon(
              Icons.person_outline, 
              size: 100, 
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 24),
            Text(
              '사용자 정보가 없습니다.',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                //상위 함수 호출해서.. 상위에 의해 화면이 바뀌게..
                showForm(true);
              },
              child: const Text('정보 입력하기'),
            ),
          ],
        ),
      ),
    );
  }
}
