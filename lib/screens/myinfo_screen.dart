import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import 'myinfo/myinfo_empty_state_widget.dart';

class MyinfoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyInfoScreenState();
  }
}

class MyInfoScreenState extends State<MyinfoScreen> {
  void handleShowForm(bool shouldShow) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Info'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
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
            icon: Icon(Icons.home),
          ),
        ],
      ),
      body: MyinfoEmptyStateWidget(handleShowForm),
    );
  }
}
