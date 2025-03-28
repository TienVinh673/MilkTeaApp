import 'package:flutter/material.dart';
import 'package:teamilkapp/Components/Colors.dart';
import 'package:teamilkapp/Components/button.dart';
import 'package:teamilkapp/Components/textfield.dart';
import 'package:teamilkapp/JSON/users.dart';
import 'package:teamilkapp/Views/signup.dart';
import 'package:teamilkapp/home_screen.dart';

import '../SQLite/database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usrName = TextEditingController();
  final password = TextEditingController();

  bool isChecked = false;
  bool isLoginTrue = false;

  final db = DatabaseHelper();
  login() async {
    // Kiểm tra các trường nhập liệu có trống không
    if (usrName.text.isEmpty || password.text.isEmpty) {
      setState(() {
        isLoginTrue = true;
      });
      return;
    }

    Users? usrDetails = await db.getUser(usrName.text);
    var res = await db.authenticate(
      Users(
        usrName: usrName.text,
        email: '', // Thêm email vì nó là required
        usrPassword: password.text,
      ),
    );
    if (res == true && usrDetails != null) {
      if (!mounted) return;
      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đăng nhập thành công!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      // Đợi 1 giây trước khi chuyển màn hình
      await Future.delayed(Duration(seconds: 1));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => HomeScreen(
                userId: usrDetails.usrId!,
                username: usrDetails.usrName,
              ),
        ),
      );
    } else {
      setState(() {
        isLoginTrue = true;
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
                const Text(
                  "ĐĂNG NHẬP",
                  style: TextStyle(color: primaryColor, fontSize: 40),
                ),
                Image.asset("assets/login.png"),
                InputField(
                  hint: "Tên đăng nhập",
                  icon: Icons.account_circle,
                  controller: usrName,
                ),
                InputField(
                  hint: "Mật khẩu",
                  icon: Icons.lock,
                  controller: password,
                  passwordInvisible: true,
                ),

                ListTile(
                  horizontalTitleGap: 2,
                  title: const Text("Ghi nhớ đăng nhập"),
                  leading: Checkbox(
                    activeColor: primaryColor,
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                  ),
                ),

                //Our login button
                Button(
                  label: "ĐĂNG NHẬP",
                  press: () {
                    login();
                  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Chưa có tài khoản?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text("ĐĂNG KÝ"),
                    ),
                  ],
                ),

                isLoginTrue
                    ? Text(
                      usrName.text.isEmpty || password.text.isEmpty
                          ? "Vui lòng nhập đầy đủ tài khoản và mật khẩu"
                          : "Tài khoản hoặc mật khẩu không chính xác",
                      style: TextStyle(color: Colors.red.shade900),
                    )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
