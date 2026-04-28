import 'package:flutter/material.dart';
import '../models/user_info.dart';
import '../services/database_helper.dart';

//앱 전역에서 공통의 데이터 유지..
//상태에서 dbms..
class UserProvider with ChangeNotifier {
  UserInfo? _userInfo;

  UserInfo? get userInfo => _userInfo;

  //저장된 user 정보가 있는지 판단하기 위해서 이용..
  bool get hasUserInfo =>
      _userInfo != null &&
      (_userInfo!.name?.isNotEmpty == true ||
          _userInfo!.email?.isNotEmpty == true);

  //초기 유저 정보를 로딩하기 위해서 호춣..
  Future<void> loadUserData() async {
    _userInfo = await DatabaseHelper.instance.getUser();
    notifyListeners();
  }

  //유저 정보 저장을 위해서 호출..
  Future<void> updateUserInfo(UserInfo userInfo) async {
    await DatabaseHelper.instance.insertOrUpdateUser(userInfo);
    _userInfo = userInfo;
    notifyListeners();
  }

  Future<void> clearUserInfo() async {
    _userInfo = null;
    notifyListeners();
  }
}
