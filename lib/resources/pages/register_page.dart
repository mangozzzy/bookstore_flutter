import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/register_api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';

class RegisterPage extends NyStatefulWidget {
  static RouteView path = ("/register", (_) => RegisterPage());
  
  RegisterPage({super.key}) : super(child: () => _RegisterPageState());
}

class _RegisterPageState extends NyPage<RegisterPage> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  final _apiService = RegisterApiService();
 
  String _selectedGender = "M"; 

  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _userIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _userIdController,
                  decoration: InputDecoration(
                    labelText: '아이디',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return '이름을 입력해주세요';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return '비밀번호를 입력해주세요';
                    }
                    if (value!.length < 6) {
                      return '비밀번호는 6자 이상이어야 합니다';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: '이름',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return '이름을 입력해주세요';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: '이메일',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: '전화번호',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: '주소',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.home),
                  ),
                ),
                TextFormField(
                  controller: _birthDateController,
                  decoration: InputDecoration(
                    labelText: '생년월일',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.cake),
                  ),
                ),
                Row(
                  children: [
                    Text("성별: "),
                    Radio(
                      value: 'M',
                      groupValue: _selectedGender,
                      onChanged: (value) => setState(() => _selectedGender = value!),
                    ),
                    Text('남성'),
                    Radio(
                      value: 'F',
                      groupValue: _selectedGender,
                      onChanged: (value) => setState(() => _selectedGender = value!),
                    ),
                    Text('여성'),
                  ],
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: '나이',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.numbers),
                  ),
                ),
                
                ElevatedButton(
                  onPressed: _handleRegister,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      '가입하기',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('이미 계정이 있으신가요?'),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('로그인'),
                    ),
                  ],
                ),
              ],
            ).withGap(10),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    await _apiService.submit(data: { 
      "userId": _userIdController.text,
      "password": _passwordController.text,
      "name": _nameController.text,
      "email": _emailController.text,
      "phoneNumber": _phoneNumberController.text,
      "address": _addressController.text,
      "birthDate": _birthDateController.text,
      "gender": _selectedGender,
      "age": _ageController.text
    });

    if (_formKey.currentState?.validate() ?? false) {
      // 회원가입 로직 구현
      showToast(
        title: "알림",
        description: "회원가입이 완료되었습니다.",
      );
      Navigator.pop(context); // 로그인 페이지로 돌아가기
    }
  }
} 