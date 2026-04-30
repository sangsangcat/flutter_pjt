import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_info.dart' as model;
import '../services/user_account_service.dart';

class UserProvider with ChangeNotifier {
  final UserAccountService _accountService = UserAccountService();

  model.UserInfo? _userInfo;
  StreamSubscription<User?>? _authSubscription;
  bool _isGoogleUser = false;

  model.UserInfo? get userInfo => _userInfo;
  bool get hasUserInfo => _userInfo != null;
  bool get isGoogleUser => _isGoogleUser;

  // 추가: 현재 로그인된 사용자의 UID 게터
  String? get userId => _accountService.currentUser?.uid;

  UserProvider() {
    // 인증 상태 실시간 모니터링
    _authSubscription = _accountService.authStateChanges.listen((User? user) {
      _updateUserInfo(user);
    });
  }

  void _updateUserInfo(User? user) {
    _userInfo = _accountService.buildUserInfo(user);
    _isGoogleUser = _accountService.isGoogleUser(user);
    notifyListeners();
  }

  // 초기 로딩 (필요한 경우 명시적 호출용)
  Future<void> loadUserData() async {
    _updateUserInfo(_accountService.currentUser);
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  // 프로필 이미지 업데이트
  Future<bool> updateProfileImage(String localPath) async {
    try {
      final downloadUrl = await _accountService.uploadProfileImage(localPath);
      if (downloadUrl == null) return false;

      _userInfo?.profileImagePath = downloadUrl;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Update Profile Image Error: $e");
      return false;
    }
  }

  // 이름 업데이트
  Future<bool> updateDisplayName(String newName) async {
    final success = await _accountService.updateDisplayName(newName);
    if (success) {
      _userInfo?.name = newName;
      notifyListeners();
    }
    return success;
  }

  // 회원 탈퇴
  Future<void> reauthenticateAndDelete(String? password) async {
    try {
      await _accountService.reauthenticateAndDelete(password);
    } catch (e) {
      debugPrint("Delete Account Error: $e");
      rethrow;
    }
  }

  // 인증 관련 대리 메서드들
  Future<bool> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    return _accountService.signUpWithEmail(email, password, name);
  }

  Future<bool> signInWithEmail(String email, String password) async {
    return _accountService.signInWithEmail(email, password);
  }

  Future<bool> signInWithGoogle() async {
    return _accountService.signInWithGoogle();
  }

  Future<void> signOut() async {
    await _accountService.signOut();
  }
}
