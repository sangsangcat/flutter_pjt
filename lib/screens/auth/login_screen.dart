// 로그인 화면: 이메일/비밀번호와 구글 로그인을 제공하는 인증 진입점.
import 'package:flutter/material.dart';
import 'package:flutter_pjt/providers/user_provider.dart';
import 'package:flutter_pjt/routes/app_routes.dart';
import 'package:flutter_pjt/theme/app_theme.dart';
import 'package:provider/provider.dart';

import 'widgets/auth_footer_row.dart';
import 'widgets/auth_header_section.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthHeaderSection(
                  icon: Icons.lock_person_outlined,
                  title: '환영합니다!',
                  subtitle: '로그인하여 더 많은 혜택을 누리세요.',
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: '이메일 주소',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return '이메일을 입력하세요';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: '비밀번호',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return '비밀번호를 입력하세요';
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // 이메일 로그인 로직 연결
                      final success = await context
                          .read<UserProvider>()
                          .signInWithEmail(
                            _emailController.text,
                            _passwordController.text,
                          );
                      if (!context.mounted) return;
                      if (success) {
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('로그인에 실패했습니다. 이메일과 비밀번호를 확인하세요.'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('로그인'),
                ),
                const SizedBox(height: 16),
                // 구글 로그인 버튼에 실제 로직 연결
                OutlinedButton.icon(
                  onPressed: () async {
                    // UserProvider의 구글 로그인 메서드 호출
                    final success = await context
                        .read<UserProvider>()
                        .signInWithGoogle();
                    if (!context.mounted) return;
                    if (success) {
                      // 로그인 성공 시 홈 화면으로 이동
                      Navigator.pushReplacementNamed(context, AppRoutes.home);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('로그인에 실패했습니다. 이메일과 비밀번호를 확인하세요.'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.login, size: 18),
                  label: const Text('Google 계정으로 계속하기'),
                  style: AppTheme.subtleOutlinedButtonStyle(),
                ),
                const SizedBox(height: 32),
                AuthFooterRow(
                  prompt: '계정이 없으신가요?',
                  actionLabel: '회원가입',
                  onActionTap: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.signup);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
