import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_pjt/providers/user_provider.dart';
import 'package:flutter_pjt/routes/app_routes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MyinfoFormWidget extends StatefulWidget {
  const MyinfoFormWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyinfoFormWidgetState();
  }
}

class MyinfoFormWidgetState extends State<MyinfoFormWidget> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController(); // 탈퇴 재인증용
  String? _tempLocalPath; 
  bool _isSaving = false; 
  ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.userInfo != null) {
      // 초기화 시 현재 서버에 저장된 이름을 불러옴
      nameController.text = userProvider.userInfo!.name ?? '';
    }
  }

  // 이미지 선택 다이얼로그
  void showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('프로필 사진 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('카메라로 촬영'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('갤러리에서 선택'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // 이미지를 선택만 하고 실제 업로드는 saveUserInfo에서 수행함
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _tempLocalPath = image.path; // 화면에 즉시 반영 (임시 상태)
        });
      }
    } catch (e) {
      debugPrint("Image Pick Error: $e");
    }
  }

  // 이름 정보와 프로필 이미지를 한꺼번에 서버에 저장
  void saveUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String newName = nameController.text.trim();

    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('이름을 입력해 주세요.')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      // 1. 이미지가 변경되었다면 서버(Storage)에 업로드
      if (_tempLocalPath != null) {
        await userProvider.updateProfileImage(_tempLocalPath!);
      }

      // 2. 이름 정보 업데이트
      await userProvider.updateDisplayName(newName);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('변경 사항이 성공적으로 저장되었습니다.')),
        );
        setState(() {
          _isSaving = false;
          _tempLocalPath = null; // 저장 완료 후 임시 상태 초기화
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('저장 중 오류가 발생했습니다.')),
        );
      }
    }
  }

  // 회원 탈퇴를 위한 재인증 다이얼로그 (비밀번호 입력)
  void showDeleteAccountDialog() {
    final userProvider = context.read<UserProvider>();
    final isGoogleUser = userProvider.isGoogleUser;
    
    passwordController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('회원 탈퇴'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('정말로 탈퇴하시겠습니까? 모든 정보가 삭제됩니다.'),
            if (!isGoogleUser) ...[
              const SizedBox(height: 16),
              const Text('본인 확인을 위해 비밀번호를 입력해 주세요.', style: TextStyle(fontSize: 12, color: Colors.grey)),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: '비밀번호'),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          TextButton(
            onPressed: () async {
              try {
                final userProvider = context.read<UserProvider>();
                // 재인증 및 탈퇴 로직 호출
                await userProvider.reauthenticateAndDelete(
                  isGoogleUser ? null : passwordController.text.trim()
                );
                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('탈퇴 처리에 실패했습니다.')));
                }
              }
            },
            child: const Text('탈퇴', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final userInfo = userProvider.userInfo;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // 1. 프로필 이미지 섹션
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 65,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      // [수정] 분기를 제거하고 CachedNetworkImageProvider 적용 유지.
                      backgroundImage: _tempLocalPath != null
                          ? FileImage(File(_tempLocalPath!)) as ImageProvider
                          : (userInfo?.profileImagePath != null
                              ? CachedNetworkImageProvider(userInfo!.profileImagePath!)
                              : const AssetImage('assets/images/user_basic.jpg') as ImageProvider),
                      child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: theme.colorScheme.secondary, // [수정] 브랜드 핑크로 포인트 부여
                        radius: 20,
                        child: IconButton(
                          onPressed: _isSaving ? null : showImagePickerDialog,
                          icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: '이름',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSaving ? null : saveUserInfo,
                child: Text(_isSaving ? '저장 중...' : '변경 사항 저장'),
              ),
              const SizedBox(height: 48),
              const Divider(),
              const SizedBox(height: 24),

              // 로그아웃 버튼
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await userProvider.signOut();
                    if (mounted) {
                      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('로그아웃'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    side: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 회원 탈퇴 버튼
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: showDeleteAccountDialog, // 재인증 다이얼로그 호출
                  icon: const Icon(Icons.person_remove_outlined, size: 18),
                  label: const Text('회원 탈퇴'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.redAccent.withValues(alpha: 0.7),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
