import 'package:flutter/material.dart';
import 'package:teamilkapp/Views/order_history_screen.dart';
import 'package:teamilkapp/SQLite/database_helper.dart';
import 'package:teamilkapp/Views/auth.dart';
import 'package:teamilkapp/Views/settings_screen.dart';
import 'package:teamilkapp/Views/help_screen.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  final String username;

  const ProfileScreen({Key? key, required this.userId, required this.username})
    : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await _db.getUserById(widget.userId);
    if (data != null) {
      setState(() {
        userData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông tin tài khoản',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.deepOrange,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.username,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildInfoSection('Thông tin cá nhân', [
              _buildInfoRow(
                'Email',
                userData?['email'] ?? 'Chưa cập nhật',
                Icons.email_outlined,
              ),
              _buildInfoRow(
                'Số điện thoại',
                userData?['phone'] ?? 'Chưa cập nhật',
                Icons.phone_outlined,
              ),
              _buildInfoRow(
                'Địa chỉ giao hàng',
                userData?['address'] ?? 'Chưa cập nhật',
                Icons.location_on_outlined,
              ),
            ]),
            const SizedBox(height: 32),
            _buildInfoSection('Quản lý tài khoản', [
              ListTile(
                leading: Icon(Icons.history, color: Colors.deepOrange),
                title: Text('Lịch sử đơn hàng'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              OrderHistoryScreen(userId: widget.userId),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.deepOrange),
                title: Text('Cài đặt tài khoản'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => SettingsScreen(
                            userId: widget.userId,
                            username: widget.username,
                          ),
                    ),
                  ).then((_) => _loadUserData());
                },
              ),
              ListTile(
                leading: Icon(Icons.help_outline, color: Colors.deepOrange),
                title: Text('Trợ giúp & Hỗ trợ'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text('Đăng xuất', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                    (route) => false,
                  );
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepOrange),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
