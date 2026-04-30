import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_info.dart' as model;
import 'auth_service.dart';
import 'storage_service.dart';

// 사용자 계정 관련 I/O를 한곳에 모아 Provider가 상태만 다루도록 돕는 서비스다.
class UserAccountService {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();

  Stream<User?> get authStateChanges => _authService.authStateChanges;
  User? get currentUser => _authService.currentUser;

  // Firebase User를 앱 내부 UserInfo 모델로 바꿔 ViewModel이 매핑 책임을 덜 갖게 한다.
  model.UserInfo? buildUserInfo(User? user) {
    if (user == null) return null;

    return model.UserInfo(
      name: user.displayName ?? '사용자',
      email: user.email,
      profileImagePath: user.photoURL,
    );
  }

  // Google 로그인 여부는 Provider가 직접 providerData를 해석하지 않도록 서비스에서 판별한다.
  bool isGoogleUser(User? user) {
    return user?.providerData.any((p) => p.providerId == 'google.com') ?? false;
  }

  Future<String?> uploadProfileImage(String localPath) async {
    final user = _authService.currentUser;
    if (user == null) return null;

    final downloadUrl = await _storageService.uploadProfileImage(
      user.uid,
      File(localPath),
    );
    await _authService.updatePhotoURL(downloadUrl);
    return downloadUrl;
  }

  Future<bool> updateDisplayName(String newName) async {
    try {
      await _authService.updateDisplayName(newName);
      return true;
    } catch (e) {
      debugPrint("Update Name Error: $e");
      return false;
    }
  }

  Future<void> reauthenticateAndDelete(String? password) async {
    final user = _authService.currentUser;
    if (user == null) return;

    AuthCredential? credential;
    final googleUser = isGoogleUser(user);

    if (googleUser) {
      credential = await _authService.getGoogleCredential();
    } else if (password != null) {
      credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
    }

    if (credential != null) {
      await _authService.reauthenticate(credential);
      await _storageService.deleteProfileImage(user.uid);
      await _authService.deleteAccount();
    }
  }

  Future<bool> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
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
