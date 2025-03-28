import 'package:flutter/material.dart';
import 'package:teamilkapp/Components/Colors.dart';
import 'package:teamilkapp/Components/button.dart';
import 'package:teamilkapp/Components/textfield.dart';
import 'package:teamilkapp/JSON/users.dart';
import 'package:teamilkapp/Views/login.dart';

import '../SQLite/database_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  //Controllers
  final fullName = TextEditingController();
  final email = TextEditingController();
  final usrName = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final db = DatabaseHelper();

  bool isSignUpError = false;
  String errorMessage = '';

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  signUp() async {
    // Kiểm tra các trường bắt buộc
    if (usrName.text.isEmpty ||
        email.text.isEmpty ||
        password.text.isEmpty ||
        confirmPassword.text.isEmpty) {
      setState(() {
        isSignUpError = true;
        errorMessage = 'Vui lòng điền đầy đủ thông tin';
      });
      return;
    }

    // Kiểm tra định dạng email
    if (!isValidEmail(email.text)) {
      setState(() {
        isSignUpError = true;
        errorMessage = 'Email không hợp lệ';
      });
      return;
    }

    // Kiểm tra độ dài mật khẩu
    if (password.text.length < 6) {
      setState(() {
        isSignUpError = true;
        errorMessage = 'Mật khẩu phải có ít nhất 6 ký tự';
      });
      return;
    }

    // Kiểm tra mật khẩu xác nhận
    if (password.text != confirmPassword.text) {
      setState(() {
        isSignUpError = true;
        errorMessage = 'Mật khẩu xác nhận không khớp';
      });
      return;
    }

    try {
      var res = await db.createUser(
        Users(
          usrName: usrName.text,
          email: email.text,
          usrPassword: password.text,
        ),
      );
      if (res > 0) {
        if (!mounted) return;
        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng ký thành công!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        // Đợi 1 giây trước khi chuyển màn hình
        await Future.delayed(Duration(seconds: 1));
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      setState(() {
        isSignUpError = true;
        errorMessage = 'Tên đăng nhập hoặc email đã tồn tại';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Đăng Ký Tài Khoản",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InputField(
                  hint: "Tên đăng nhập",
                  icon: Icons.account_circle,
                  controller: usrName,
                ),
                InputField(hint: "Email", icon: Icons.email, controller: email),
                InputField(
                  hint: "Mật khẩu",
                  icon: Icons.lock,
                  controller: password,
                  passwordInvisible: true,
                ),
                InputField(
                  hint: "Nhập lại mật khẩu",
                  icon: Icons.lock,
                  controller: confirmPassword,
                  passwordInvisible: true,
                ),
                const SizedBox(height: 10),
                Button(
                  label: "ĐĂNG KÝ",
                  press: () {
                    signUp();
                  },
                ),
                if (isSignUpError)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red.shade900),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Đã có tài khoản?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text("ĐĂNG NHẬP"),
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
