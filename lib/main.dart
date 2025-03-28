import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teamilkapp/Views/auth.dart';
import 'package:teamilkapp/SQLite/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo database
  final db = DatabaseHelper();

  // Đảm bảo database được tạo
  await db.initDB();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange, fontFamily: 'Poppins'),
      // home: HomeScreen(),
      home: const AuthScreen(),
    );
  }
}
