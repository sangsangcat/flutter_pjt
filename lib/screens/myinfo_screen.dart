import 'package:flutter/material.dart';
import 'package:flutter_pjt/screens/myinfo/myinfo_form_widget.dart';
import '../routes/app_routes.dart';
import 'myinfo/myinfo_empty_state_widget.dart';

class MyinfoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyInfoScreenState();
  }
}

class MyInfoScreenState extends State<MyinfoScreen> {

  bool showForm = false;

  void handleShowForm(bool shouldShow) {
    //화면 업데이트..
    setState(() {
      showForm = shouldShow;
    });
  }

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
      body: showForm ? MyinfoFormWidget() : MyinfoEmptyStateWidget(handleShowForm),
    );
  }
}
