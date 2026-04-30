import 'package:flutter/material.dart';
import 'package:flutter_pjt/providers/user_provider.dart';
import 'package:flutter_pjt/routes/app_routes.dart';
import 'package:provider/provider.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // [수정] 브랜드 컬러와 테마 스타일 적용
                Icon(
                  Icons.lock_person_outlined, 
                  size: 80, 
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  '환영합니다!',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displayLarge?.copyWith(fontSize: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  '로그인하여 더 많은 혜택을 누리세요.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
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
                      final success = await context.read<UserProvider>().signInWithEmail(
                            _emailController.text,
                            _passwordController.text,
                          );
                      if (success && mounted) {
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      } else if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('로그인에 실패했습니다. 이메일과 비밀번호를 확인하세요.')),
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
                    final success = await context.read<UserProvider>().signInWithGoogle();
                    if (success && mounted) {
                      // 로그인 성공 시 홈 화면으로 이동
                      Navigator.pushReplacementNamed(context, AppRoutes.home);
                    } else if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('로그인에 실패했습니다. 이메일과 비밀번호를 확인하세요.')),
                      );
                    }
                  },
                  icon: const Icon(Icons.login, size: 18),
                  label: const Text('Google 계정으로 계속하기'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
                    foregroundColor: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '계정이 없으신가요?',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.signup);
                      },
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
