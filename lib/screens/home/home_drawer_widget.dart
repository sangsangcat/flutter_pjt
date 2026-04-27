import 'package:flutter/material.dart';
import 'package:flutter_pjt/routes/app_routes.dart';

class HomeDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          //drawer header 에 일반적으로는 사용자 프로필 정보..
          //프사, 아이디.. 부가정보..
          UserAccountsDrawerHeader(
            accountName: Text('사용자'),
            accountEmail: Text('a@a.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/user_basic.jpg'),
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: (){
              //Drawer 를 닫는다..
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.about);
            },
          ),
        ],
      ),
    );
  }
}
