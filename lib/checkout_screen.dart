import 'package:flutter/material.dart';
import 'package:teamilkapp/JSON/order.dart';
import 'package:teamilkapp/SQLite/database_helper.dart';
import 'package:teamilkapp/Views/order_history_screen.dart';
import 'package:teamilkapp/home_screen.dart';
import 'package:teamilkapp/cart_screen.dart';
import 'package:intl/intl.dart';

class CheckoutScreen extends StatefulWidget {
  final int userId;
  final String username;
  final List<OrderItem> cartItems;
  final int totalAmount;

  const CheckoutScreen({
    super.key,
    required this.userId,
    required this.username,
    required this.cartItems,
    required this.totalAmount,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPaymentMethod = 0;
  final _noteController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bankAccountController = TextEditingController();
  String _selectedBank = 'Vietcombank';
  final _db = DatabaseHelper();
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
  bool _isProcessing = false;

  final List<String> _banks = [
    'Vietcombank',
    'BIDV',
    'Agribank',
    'Techcombank',
    'MB Bank',
    'ACB',
    'VPBank',
    'Sacombank',
  ];

  Future<bool?> _showConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận đơn hàng'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Chi tiết đơn hàng:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ...widget.cartItems
                    .map(
                      (item) => Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.productName),
                            Text(
                              'Size: ${item.size ?? "M"}${item.extras != null ? " - ${item.extras}" : ""}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${item.quantity}x ${currencyFormat.format(item.price)}',
                              style: TextStyle(color: Colors.deepOrange),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                SizedBox(height: 10),
                Text(
                  'Phương thức thanh toán:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_getPaymentMethodText()),
                SizedBox(height: 10),
                Text(
                  'Tổng tiền:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  currencyFormat.format(widget.totalAmount),
                  style: TextStyle(color: Colors.deepOrange, fontSize: 18),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
              child: Text('Xác nhận thanh toán'),
            ),
          ],
        );
      },
    );
  }

  String _getPaymentMethodText() {
    switch (_selectedPaymentMethod) {
      case 0:
        return 'Tiền mặt';
      case 1:
        return 'Ngân hàng: $_selectedBank\nSố tài khoản: ${_bankAccountController.text}';
      case 2:
        return 'Momo: ${_phoneController.text}';
      default:
        return '';
    }
  }

  Future<void> _placeOrder() async {
    if (_isProcessing) return;

    // Kiểm tra thông tin thanh toán
    if (_selectedPaymentMethod == 1 && _bankAccountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập số tài khoản ngân hàng')),
      );
      return;
    }

    if (_selectedPaymentMethod == 2 && _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập số điện thoại Momo')),
      );
      return;
    }

    bool? confirmed = await _showConfirmationDialog();
    if (confirmed != true) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final order = Order(
        userId: widget.userId,
        orderDate: DateTime.now().toIso8601String(),
        totalAmount: widget.totalAmount,
        status: 'Hoàn thành',
        items: widget.cartItems,
      );

      final orderId = await _db.createOrder(order);
      print('Đơn hàng đã được tạo với ID: $orderId');

      if (!mounted) return;

      // Xóa giỏ hàng
      CartManager.cartItems.clear();

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đặt hàng thành công!'),
          duration: Duration(seconds: 2),
        ),
      );

      // Quay về màn hình chính với thông tin user
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder:
              (context) =>
                  HomeScreen(userId: widget.userId, username: widget.username),
        ),
        (route) => false,
      );
    } catch (e) {
      print('Lỗi khi tạo đơn hàng: $e');
      if (!mounted) return;

      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Thanh Toán",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 2,
                  blurRadius: 1,
                ),
              ],
            ),
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionCard(
                        'Tóm tắt đơn hàng',
                        Column(
                          children: [
                            ...widget.cartItems
                                .map(
                                  (item) => Column(
                                    children: [
                                      _buildOrderItem(
                                        item.productName,
                                        currencyFormat.format(item.price),
                                        'Size: ${item.size ?? "M"}${item.extras != null ? " - ${item.extras}" : ""}',
                                      ),
                                      if (item != widget.cartItems.last)
                                        Divider(height: 20),
                                    ],
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildSectionCard(
                        'Phương thức thanh toán',
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _buildPaymentOption(0, 'Tiền mặt', Icons.money),
                                SizedBox(width: 12),
                                _buildPaymentOption(
                                  1,
                                  'Ngân hàng',
                                  Icons.account_balance,
                                ),
                                SizedBox(width: 12),
                                _buildPaymentOption(
                                  2,
                                  'Momo',
                                  Icons.account_balance_wallet,
                                ),
                              ],
                            ),
                            _buildPaymentDetails(),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildSectionCard(
                        'Ghi chú',
                        TextField(
                          controller: _noteController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText:
                                "Thêm ghi chú cho đơn hàng (không bắt buộc)",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSummaryRow(
                      'Tổng thanh toán',
                      currencyFormat.format(widget.totalAmount),
                      isTotal: true,
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _placeOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child:
                            _isProcessing
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                  "Đặt hàng - ${currencyFormat.format(widget.totalAmount)}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, Widget content) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildOrderItem(String name, String price, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                description,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(int index, String title, IconData icon) {
    final isSelected = _selectedPaymentMethod == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPaymentMethod = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.deepOrange : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.deepOrange : Colors.grey.shade300,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.grey[600]),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentDetails() {
    switch (_selectedPaymentMethod) {
      case 1: // Ngân hàng
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedBank,
              decoration: InputDecoration(
                labelText: 'Chọn ngân hàng',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items:
                  _banks.map((bank) {
                    return DropdownMenuItem(value: bank, child: Text(bank));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBank = value!;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _bankAccountController,
              decoration: InputDecoration(
                labelText: 'Số tài khoản',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        );
      case 2: // Momo
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Số điện thoại Momo',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        );
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildSummaryRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? Colors.black : Colors.grey[600],
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: isTotal ? Colors.black : Colors.black,
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
