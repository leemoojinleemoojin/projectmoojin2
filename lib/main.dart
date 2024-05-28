import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedDomain = 'naver.com'; // 추가된 부분

  LoginPage({Key? key}) : super(key: key); // 수정된 부분

  Future<void> login(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('이메일과 비밀번호를 입력하세요.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');

    if (email == savedEmail && password == savedPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('로그인 성공'),
      ));
      // 로그인 후 다음 화면으로 네비게이션 또는 작업 수행
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('로그인 실패'),
      ));
    }
  }

  Future<void> forgotPassword(BuildContext context) async {
    final email = emailController.text;

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('이메일을 입력하세요.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');

    if (email == savedEmail) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('비밀번호'),
          content: Text('회원님의 비밀번호는 $savedPassword 입니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('닫기'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('등록되지 않은 이메일입니다.'),
        backgroundColor: Colors.red,
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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Container(
                    margin: EdgeInsets.only(top: 4.0), // 살짝 위로 올림
                    child: DropdownButton<String>(
                      value: selectedDomain,
                      onChanged: (newValue) {
                        selectedDomain = newValue!;
                      },
                      items: <String>['naver.com', 'google.com']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: BoxDecoration( // 드롭다운 버튼의 테두리 스타일 지정
                        border: Border.all(color: Colors.black), // 검은색 테두리
                        borderRadius: BorderRadius.circular(4.0), // 둥근 모서리
                      ),
                    ),
                  ),
                ],
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
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  ).then((_) {
                    // 회원가입 페이지에서 돌아왔을 때 실행될 코드
                    emailController.clear(); // 이메일 필드 초기화
                    passwordController.clear(); // 비밀번호 필드 초기화
                  });
                },
                child: const Text('회원가입'),
              ),
              const SizedBox(height: 8.0),
              TextButton(
                onPressed: () => forgotPassword(context),
                child: const Text('비밀번호를 잊으셨나요?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController(); // 추가된 부분

  SignUpPage({Key? key}) : super(key: key); // 수정된 부분

  String selectedDomain = 'naver.com'; // 추가된 부분

  Future<void> signUp(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text; // 추가된 부분

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('이메일, 비밀번호, 확인된 비밀번호를 입력하세요.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (password.length < 10) {
      // 비밀번호가 10자리 미만인 경우
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('비밀번호는 10자리 이상이어야 합니다.'),
        backgroundColor: Colors.red,
      ));
      return; // 회원가입 중단
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      // 대문자가 없는 경우
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('비밀번호에는 반드시 대문자가 하나 이상 포함되어야 합니다.'),
        backgroundColor: Colors.red,
      ));
      return; // 회원가입 중단
    }

    if (password != confirmPassword) {
      // 비밀번호와 확인된 비밀번호가 일치하지 않는 경우
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('비밀번호와 확인된 비밀번호가 일치하지 않습니다.'),
        backgroundColor: Colors.red,
      ));
      return; // 회원가입 중단
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email + '@' + selectedDomain); // 수정된 부분
    await prefs.setString('password', password);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('회원가입 성공'),
    ));
    // 회원가입 성공 시 로그인 페이지로 이동
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Container(
                    margin: EdgeInsets.only(top: 4.0), // 살짝 위로 올림
                    child: DropdownButton<String>(
                      value: selectedDomain,
                      onChanged: (newValue) {
                        selectedDomain = newValue!;
                      },
                      items: <String>['naver.com', 'google.com']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: BoxDecoration( // 드롭다운 버튼의 테두리 스타일 지정
                        border: Border.all(color: Colors.black), // 검은색 테두리
                        borderRadius: BorderRadius.circular(4.0), // 둥근 모서리
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => signUp(context),
                child: const Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


















