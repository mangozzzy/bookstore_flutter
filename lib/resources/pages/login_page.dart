import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/login_api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';

class LoginPage extends NyStatefulWidget {
  static RouteView path = ("/login", (_) => LoginPage());
  
  LoginPage({super.key}) : super(child: () => _LoginPageState());
}

class _LoginPageState extends NyPage<LoginPage> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _apiService = LoginApiService();

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  get init => () {};

  Future<void> _handleLogin() async {
    final res =  await _apiService.submit(data: {
      "userId": _userIdController.text,
      "password": _passwordController.text,
    });

    if (res != null) {
      await Auth.authenticate(data: { "userId": res.userId }); 
      await storageSave("password", _passwordController.text);
    }
  
    if ((_formKey.currentState?.validate() ?? false) && (res?.success ?? false)) {
      try {
        // 임시 로그인 성공 처리
        showToast(
          title: "환영합니다",
          description: "${_userIdController.text}님 로그인되었습니다.",
        );
        
        // 프페이지로 이동 (프로필 페이지가 아닌)
        Navigator.pushReplacementNamed(context, '/home');
        await storageSave("userId", res?.userId);
      } catch (e) {
        showToast(
          title: "오류",
          description: "로그인에 실패했습니다. 다시 시도해주세요.",
        );
      }
    }
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("로그인"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _userIdController,
                  decoration: InputDecoration(
                    labelText: '아이디',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return '아이디를 입력해주세요';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return '비밀번호를 입력해주세요';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _handleLogin,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      '로그인',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgot-password');
                      },
                      child: Text('비밀번호를 잊으셨나요?'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text('회원가입'),
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
