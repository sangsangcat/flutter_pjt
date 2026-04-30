import 'package:flutter/material.dart';
import 'package:flutter_pjt/providers/user_provider.dart';
import 'package:flutter_pjt/routes/app_routes.dart';
import 'package:flutter_pjt/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'delete_account_dialog.dart';
import 'image_picker_dialog.dart';
import 'profile_avatar_section.dart';

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
      builder: (dialogContext) => ImagePickerDialog(
        onCameraTap: () {
          Navigator.pop(dialogContext);
          pickImage(ImageSource.camera);
        },
        onGalleryTap: () {
          Navigator.pop(dialogContext);
          pickImage(ImageSource.gallery);
        },
      ),
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('이름을 입력해 주세요.')));
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('변경 사항이 성공적으로 저장되었습니다.')));
        setState(() {
          _isSaving = false;
          _tempLocalPath = null; // 저장 완료 후 임시 상태 초기화
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('저장 중 오류가 발생했습니다.')));
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
      builder: (dialogContext) => DeleteAccountDialog(
        isGoogleUser: isGoogleUser,
        passwordController: passwordController,
        onConfirm: (password) async {
          try {
            final userProvider = context.read<UserProvider>();
            // 재인증 및 탈퇴 로직 호출
            await userProvider.reauthenticateAndDelete(password);
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('탈퇴 처리에 실패했습니다.')));
            }
          }
        },
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
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final userInfo = userProvider.userInfo;
        final avatarPath = userInfo?.profileImagePath;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // 1. 프로필 이미지 섹션
              ProfileAvatarSection(
                tempLocalPath: _tempLocalPath,
                avatarPath: avatarPath,
                isSaving: _isSaving,
                onTapCamera: showImagePickerDialog,
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
                    if (!context.mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('로그아웃'),
                  style: AppTheme.subtleOutlinedButtonStyle(),
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
                  style: AppTheme.dangerTextButtonStyle(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
