
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  Future<void> login(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;

    // 여기서는 간단한 예시로 SharedPreferences를 사용하여 사용자 정보를 저장합니다.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');

    if (email == savedEmail && password == savedPassword) {
      // 로그인 성공
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('로그인 성공'),
      ));
      // 로그인 후 다음 화면으로 네비게이션 또는 작업 수행
    } else {
      // 로그인 실패
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('로그인 실패'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => login(context),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}


