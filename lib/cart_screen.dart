import 'package:flutter/material.dart';
import 'package:teamilkapp/checkout_screen.dart';
import 'package:teamilkapp/JSON/order.dart';

class CartItem {
  final String name;
  final String price;
  final String image;
  final String? size;
  final String? extras;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.image,
    this.size,
    this.extras,
    this.quantity = 1,
  });
}

class CartManager {
  static List<CartItem> cartItems = [];

  static double get totalAmount {
    return cartItems.fold(
      0,
      (sum, item) => sum + (double.parse(item.price) * item.quantity),
    );
  }

  static void addItem(CartItem item) {
    final existingItemIndex = cartItems.indexWhere((i) => i.name == item.name);
    if (existingItemIndex >= 0) {
      cartItems[existingItemIndex].quantity += 1;
    } else {
      cartItems.add(item);
    }
  }

  static void removeItem(int index) {
    cartItems.removeAt(index);
  }

  static void updateQuantity(int index, int quantity) {
    if (quantity <= 0) {
      removeItem(index);
    } else {
      cartItems[index].quantity = quantity;
    }
  }
}

// Thêm enum cho phương thức thanh toán
enum PaymentMethod { cash, bank }

class CartScreen extends StatefulWidget {
  final int userId;
  final String username;

  const CartScreen({super.key, required this.userId, required this.username});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;

  void _navigateToCheckout() {
    final cartItems =
        CartManager.cartItems
            .map(
              (item) => OrderItem(
                productName: item.name,
                quantity: item.quantity,
                price: double.parse(item.price).toInt(),
                size: item.size,
                extras: item.extras,
              ),
            )
            .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CheckoutScreen(
              userId: widget.userId,
              username: widget.username,
              cartItems: cartItems,
              totalAmount: CartManager.totalAmount.toInt(),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          CartManager.cartItems.isEmpty
              ? _buildEmptyCart()
              : Column(
                children: [
                  Expanded(child: _buildCartList()),
                  _buildBottomBar(),
                ],
              ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'Giỏ hàng hiện đang trống',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Hãy thêm sản phẩm vào giỏ hàng',
            style: TextStyle(color: Colors.grey[500]),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text('Tiếp tục mua sắm'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: CartManager.cartItems.length,
      itemBuilder: (context, index) {
        final item = CartManager.cartItems[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    item.image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (item.size != null || item.extras != null)
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            [
                              if (item.size != null) 'Size: ${item.size}',
                              if (item.extras != null) 'Extras: ${item.extras}',
                            ].join('\n'),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      SizedBox(height: 4),
                      Text(
                        '${item.price}đ',
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        setState(() {
                          if (item.quantity > 1) {
                            item.quantity--;
                          } else {
                            CartManager.cartItems.removeAt(index);
                          }
                        });
                      },
                    ),
                    Text(
                      '${item.quantity}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setState(() {
                          item.quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng tiền:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${CartManager.totalAmount.toStringAsFixed(0)}đ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _navigateToCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Tiến hành thanh toán',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
