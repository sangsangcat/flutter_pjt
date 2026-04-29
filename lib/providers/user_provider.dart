import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_info.dart' as model;
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();

  model.UserInfo? _userInfo;
  StreamSubscription<User?>? _authSubscription;
  bool _isGoogleUser = false;

  model.UserInfo? get userInfo => _userInfo;
  bool get hasUserInfo => _userInfo != null;
  bool get isGoogleUser => _isGoogleUser;

  // 추가: 현재 로그인된 사용자의 UID 게터
  String? get userId => _authService.currentUser?.uid;

  UserProvider() {
    // 인증 상태 실시간 모니터링
    _authSubscription = _authService.authStateChanges.listen((User? user) {
      _updateUserInfo(user);
    });
  }

  void _updateUserInfo(User? user) {
    if (user != null) {
      _userInfo = model.UserInfo(
        name: user.displayName ?? '사용자',
        email: user.email,
        profileImagePath: user.photoURL,
      );
      _isGoogleUser = user.providerData.any((p) => p.providerId == 'google.com');
    } else {
      _userInfo = null;
      _isGoogleUser = false;
    }
    notifyListeners();
  }

  // 초기 로딩 (필요한 경우 명시적 호출용)
  Future<void> loadUserData() async {
    _updateUserInfo(_authService.currentUser);
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  // 프로필 이미지 업데이트
  Future<bool> updateProfileImage(String localPath) async {
    try {
      final user = _authService.currentUser;
      if (user == null) return false;

      final downloadUrl = await _storageService.uploadProfileImage(user.uid, File(localPath));
      await _authService.updatePhotoURL(downloadUrl);
      
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
    try {
      await _authService.updateDisplayName(newName);
      _userInfo?.name = newName;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Update Name Error: $e");
      return false;
    }
  }

  // 회원 탈퇴
  Future<void> reauthenticateAndDelete(String? password) async {
    try {
      final user = _authService.currentUser;
      if (user == null) return;

      AuthCredential? credential;
      if (_isGoogleUser) {
        credential = await _authService.getGoogleCredential();
      } else if (password != null) {
        credential = EmailAuthProvider.credential(email: user.email!, password: password);
      }

      if (credential != null) {
        await _authService.reauthenticate(credential);
        await _storageService.deleteProfileImage(user.uid);
        await _authService.deleteAccount();
      }
    } catch (e) {
      debugPrint("Delete Account Error: $e");
      rethrow;
    }
  }

  // 인증 관련 대리 메서드들
  Future<bool> signUpWithEmail(String email, String password, String name) async {
    try {
      await _authService.signUpWithEmail(email, password);
      await _authService.updateDisplayName(name);
      return true;
    } catch (e) {
      debugPrint("Sign-Up Error: $e");
      return false;
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      await _authService.signInWithEmail(email, password);
      return true;
    } catch (e) {
      debugPrint("Sign-In Error: $e");
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      final result = await _authService.signInWithGoogle();
      return result != null;
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
