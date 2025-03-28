class OrderItem {
  final String productName;
  final int quantity;
  final int price;
  final String? size;
  final String? extras;

  OrderItem({
    required this.productName,
    required this.quantity,
    required this.price,
    this.size,
    this.extras,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'size': size,
      'extras': extras,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productName: map['productName'],
      quantity: map['quantity'],
      price: map['price'],
      size: map['size'],
      extras: map['extras'],
    );
  }
}

class Order {
  final int? orderId;
  final int userId;
  final String orderDate;
  final int totalAmount;
  final String status;
  final List<OrderItem> items;

  Order({
    this.orderId,
    required this.userId,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'orderDate': orderDate,
      'totalAmount': totalAmount,
      'status': status,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, List<OrderItem> items) {
    return Order(
      orderId: map['orderId'],
      userId: map['userId'],
      orderDate: map['orderDate'],
      totalAmount: map['totalAmount'],
      status: map['status'],
      items: items,
    );
  }
}
