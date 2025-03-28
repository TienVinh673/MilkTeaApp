import 'package:flutter/material.dart';
import 'package:teamilkapp/JSON/order.dart';
import 'package:teamilkapp/SQLite/database_helper.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  final int userId;

  const OrderHistoryScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  List<Order> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final orders = await _db.getUserOrders(widget.userId);
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải lịch sử đơn hàng: $e')),
      );
    }
  }

  String _formatDateTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return formatter.format(amount);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'hoàn thành':
        return Colors.green;
      case 'đã hủy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử đơn hàng'),
        backgroundColor: Colors.deepOrange,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _orders.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Chưa có đơn hàng nào',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ExpansionTile(
                      title: Text(
                        'Đơn hàng #${order.orderId}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_formatDateTime(order.orderDate)),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(order.status),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  order.status,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Spacer(),
                              Text(
                                _formatCurrency(order.totalAmount),
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: order.items.length,
                          itemBuilder: (context, itemIndex) {
                            final item = order.items[itemIndex];
                            return ListTile(
                              title: Text(item.productName),
                              subtitle: Text(
                                'Size: ${item.size ?? "N/A"}\n'
                                'Extras: ${item.extras ?? "Không"}',
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('x${item.quantity}'),
                                  Text(
                                    _formatCurrency(item.price * item.quantity),
                                    style: TextStyle(color: Colors.deepOrange),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
