import 'package:flutter/material.dart';
import 'package:teamilkapp/SQLite/database_helper.dart';

class SettingsScreen extends StatefulWidget {
  final int userId;
  final String username;

  const SettingsScreen({Key? key, required this.userId, required this.username})
    : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  Map<String, dynamic>? userData;
  bool orderNotifications = true;
  bool promoNotifications = false;

  // Controllers for editing
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _addressController.text = data['address'] ?? '';
      });
    }
  }

  Future<void> _updateUserInfo() async {
    try {
      await _db.updateUser(
        widget.userId,
        widget.username,
        _emailController.text,
        _phoneController.text,
        _addressController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật thông tin thành công'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi cập nhật thông tin: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu mới không khớp'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final currentUser = await _db.getUserById(widget.userId);
      if (currentUser != null &&
          currentUser['usrPassword'] == _currentPasswordController.text) {
        await _db.updatePassword(widget.userId, _newPasswordController.text);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đổi mật khẩu thành công'),
              backgroundColor: Colors.green,
            ),
          );
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mật khẩu hiện tại không đúng'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi đổi mật khẩu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Đổi mật khẩu'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _currentPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu hiện tại',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _newPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu mới',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Xác nhận mật khẩu mới',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                ),
                child: Text('Đổi mật khẩu'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Cài đặt tài khoản',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _updateUserInfo,
            child: Text(
              'Lưu',
              style: TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSection('Thông tin tài khoản', [
            _buildTextField(
              'Email',
              _emailController,
              Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            _buildTextField(
              'Số điện thoại',
              _phoneController,
              Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            _buildTextField(
              'Địa chỉ giao hàng',
              _addressController,
              Icons.location_on_outlined,
              maxLines: 2,
            ),
          ]),
          SizedBox(height: 24),
          _buildSection('Bảo mật', [
            ListTile(
              leading: Icon(Icons.lock_outline, color: Colors.deepOrange),
              title: Text('Đổi mật khẩu'),
              onTap: _showChangePasswordDialog,
            ),
          ]),
          SizedBox(height: 24),
          _buildSection('Thông báo', [
            SwitchListTile(
              secondary: Icon(
                Icons.notifications_outlined,
                color: Colors.deepOrange,
              ),
              title: Text('Thông báo đơn hàng'),
              subtitle: Text('Nhận thông báo về trạng thái đơn hàng'),
              value: orderNotifications,
              onChanged: (value) {
                setState(() => orderNotifications = value);
              },
              activeColor: Colors.deepOrange,
            ),
            SwitchListTile(
              secondary: Icon(
                Icons.local_offer_outlined,
                color: Colors.deepOrange,
              ),
              title: Text('Thông báo khuyến mãi'),
              subtitle: Text('Nhận thông báo về ưu đãi và khuyến mãi'),
              value: promoNotifications,
              onChanged: (value) {
                setState(() => promoNotifications = value);
              },
              activeColor: Colors.deepOrange,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.deepOrange),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.deepOrange),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
