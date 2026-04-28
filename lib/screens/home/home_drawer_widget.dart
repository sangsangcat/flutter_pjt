import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pjt/providers/user_provider.dart';
import 'package:flutter_pjt/routes/app_routes.dart';
import 'package:provider/provider.dart';

class HomeDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              //drawer header 에 일반적으로는 사용자 프로필 정보..
              //프사, 아이디.. 부가정보..
              return UserAccountsDrawerHeader(
                accountName: Text(userProvider.userInfo?.name ?? '사용자'),
                accountEmail: Text(userProvider.userInfo?.email ?? 'a@a.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      userProvider.userInfo?.profileImagePath != null
                      ? FileImage(
                          File(userProvider.userInfo!.profileImagePath!),
                        )
                      : AssetImage('assets/images/user_basic.jpg'),
                ),
                decoration: BoxDecoration(color: Colors.blue),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              //Drawer 를 닫는다..
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.about);
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('My Info'),
            onTap: () {
              //Drawer 를 닫는다..
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.myInfo);
            },
          ),
        ],
      ),
    );
  }
}
