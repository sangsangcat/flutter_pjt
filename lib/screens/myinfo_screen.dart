import 'package:flutter/material.dart';
import 'package:flutter_pjt/providers/user_provider.dart';
import 'package:flutter_pjt/screens/myinfo/myinfo_form_widget.dart';
import 'package:provider/provider.dart';
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

  //초기 로딩되면서.. 상태 정보 있는지 판단..
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.userInfo != null) {
      showForm = true;
    }
  }

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
      //initState 에서 판단에 의해 상태 있는지 값 유지.. 최초 한번..
      //empty 위젯에서..  form 위젯으로 이동해서 상태 발생하는 경우..
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (!userProvider.hasUserInfo && !showForm) {
            return MyinfoEmptyStateWidget(handleShowForm);
          } else {
            return MyinfoFormWidget();
          }
        },
      ),
    );
  }
}
