import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

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
          'Trợ giúp & Hỗ trợ',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSection('Câu hỏi thường gặp', [
            _buildExpandableTile(
              'Làm thế nào để đặt hàng?',
              'Để đặt hàng, bạn có thể thực hiện các bước sau:\n'
                  '1. Chọn sản phẩm muốn mua\n'
                  '2. Chọn size và topping (nếu có)\n'
                  '3. Thêm vào giỏ hàng\n'
                  '4. Vào giỏ hàng và nhấn "Thanh toán"\n'
                  '5. Chọn phương thức thanh toán và xác nhận đơn hàng',
            ),
            _buildExpandableTile(
              'Các phương thức thanh toán?',
              'Chúng tôi hỗ trợ các phương thức thanh toán sau:\n'
                  '- Tiền mặt\n'
                  '- Chuyển khoản ngân hàng\n'
                  '- Ví điện tử MoMo',
            ),
            _buildExpandableTile(
              'Chính sách đổi trả?',
              'Chúng tôi sẽ đổi sản phẩm mới cho bạn nếu:\n'
                  '- Sản phẩm bị lỗi do nhà sản xuất\n'
                  '- Sản phẩm không đúng với đơn đặt hàng\n'
                  '- Thời gian phản hồi trong vòng 30 phút sau khi nhận hàng',
            ),
          ]),
          SizedBox(height: 24),
          _buildSection('Liên hệ hỗ trợ', [
            _buildContactTile('Hotline', '1900 xxxx', Icons.phone_outlined),
            _buildContactTile(
              'Email',
              'support@bubbletea.com',
              Icons.email_outlined,
            ),
            _buildContactTile(
              'Facebook',
              'Bubble Tea Vietnam',
              Icons.facebook_outlined,
            ),
          ]),
          SizedBox(height: 24),
          _buildSection('Về chúng tôi', [
            _buildListTile('Điều khoản sử dụng', Icons.description_outlined),
            _buildListTile('Chính sách bảo mật', Icons.security_outlined),
            _buildListTile(
              'Phiên bản ứng dụng',
              Icons.info_outline,
              subtitle: '1.0.0',
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

  Widget _buildExpandableTile(String title, String content) {
    return ExpansionTile(
      title: Text(title),
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            content,
            style: TextStyle(color: Colors.grey[600], height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildContactTile(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepOrange),
      title: Text(title),
      subtitle: Text(value),
      onTap: () {
        // TODO: Implement contact actions
      },
    );
  }

  Widget _buildListTile(String title, IconData icon, {String? subtitle}) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepOrange),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Implement navigation
      },
    );
  }
}
