import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import 'about/about_portrait_widget.dart';

class AboutScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
              onPressed: (){
                //home 화면으로 이동..
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false
                );
              },
              icon: Icon(Icons.home),
          ),
        ],
      ),
      //화면 방향 감지해서.. 맞는 위젯을 출력.. 가로/세로 방향에 대응..
      //화면 회전이 발생하면 함수 자동 호출..
      body: OrientationBuilder(
          builder: (context, orientation){
            if(orientation == Orientation.portrait){
              return AboutPortraitWidget();
            } else {
              return Text('가로방향');
            }
          }
      ),
    );
  }
}