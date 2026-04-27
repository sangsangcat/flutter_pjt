import 'package:flutter/material.dart';
import './routes/app_routes.dart';
import './screens/home_screen.dart';

void main() {
  //constant constructor, const 예약어로 생성, 필수는 아니지만 위젯에서 권장사항..
  //동일 매개변수로 객체 재사용.. 위젯은 불변이기 때문에..
  runApp(const TripApp());
}

class TripApp extends StatelessWidget {
  //모든 위젯은 키를 가질 수 있다..
  const TripApp({super.key});

  @override
  Widget build(BuildContext context) {
    //테마설정 + 라우팅 등록 + 앱 전역 상태 등록
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      routes: {AppRoutes.home: (context) => HomeScreen()},
    );
  }
}
