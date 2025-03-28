import 'package:flutter/material.dart';
import 'package:teamilkapp/Components/Colors.dart';
import 'package:teamilkapp/Components/button.dart';
import 'package:teamilkapp/Views/login.dart';
import 'package:teamilkapp/Views/signup.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Bubble Tea",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const Text(
                  "Thêm chút ngọt ngào cho ngày mới",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(child: Image.asset("assets/login.png")),
                Button(
                  label: "ĐĂNG NHẬP",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
                Button(
                  label: "ĐĂNG KÝ",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
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
