import 'package:flutter/material.dart';

class MyinfoEmptyStateWidget extends StatelessWidget {
  //상위 위젯의 함수.. 생성자 매개변수로 받아서.. 이벤트 발생시에 호출..
  final Function(bool) showForm;

  MyinfoEmptyStateWidget(this.showForm);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, size: 100, color: Colors.grey),
          SizedBox(height: 24),
          Text(
            '사용자 정보가 없습니다.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              //상위 함수 호출해서.. 상위에 의해 화면이 바뀌게..
              showForm(true);
            },
            child: Text('정보 입력하기'),
          ),
        ],
      ),
    );
  }
}
