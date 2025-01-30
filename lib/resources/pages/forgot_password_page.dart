import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class ForgotPasswordPage extends NyStatefulWidget {
  static RouteView path = ("/forgot-password", (_) => ForgotPasswordPage());
  
  ForgotPasswordPage({super.key}) : super(child: () => _ForgotPasswordPageState());
}

class _ForgotPasswordPageState extends NyState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleFindPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      // 실제 비밀번호 찾기 로직 구현
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('임시 비밀번호 발송'),
          content: Text('입력하신 이메일로 임시 비밀번호가 발송되었습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
                Navigator.pop(context); // 비밀번호 찾기 페이지 닫기
              },
              child: Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 찾기'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '가입 시 등록한 아이디와 이메일을 입력해주세요.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 24),
                TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: '아이디',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return '아이디를 입력해주세요';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: '이메일',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return '이메일을 입력해주세요';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                      return '올바른 이메일 형식이 아닙니다';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _handleFindPassword,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    '비밀번호 찾기',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 