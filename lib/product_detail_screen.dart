import 'package:flutter/material.dart';
import 'package:teamilkapp/cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final String name;
  final String price;
  final String image;
  final String rating;
  final bool isCoffee;
  final int userId;
  final String username;

  const ProductDetailScreen({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.rating,
    required this.isCoffee,
    required this.userId,
    required this.username,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String selectedSize = 'M';
  Map<String, bool> selectedExtras = {
    'Thạch': false,
    'Chân châu trắng': false,
    'Pudding': false,
  };

  int get basePrice {
    if (widget.isCoffee) {
      return int.parse(widget.price);
    }
    // Giá cơ bản cho trà sữa theo size
    switch (selectedSize) {
      case 'S':
        return 25000;
      case 'M':
        return 30000;
      case 'L':
        return 35000;
      default:
        return 30000;
    }
  }

  int get extrasPrice {
    if (!widget.isCoffee) {
      int total = 0;
      selectedExtras.forEach((extra, isSelected) {
        if (isSelected) {
          switch (extra) {
            case 'Thạch':
            case 'Chân châu trắng':
              total += 5000;
              break;
            case 'Pudding':
              total += 7000;
              break;
          }
        }
      });
      return total;
    }
    return 0;
  }

  int get totalPrice => basePrice + extrasPrice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.deepOrange,
            flexibleSpace: Stack(
              children: [
                Image.asset(
                  widget.image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.transparent,
                        Colors.black.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.name,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.deepOrange.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.deepOrange,
                                size: 20,
                              ),
                              SizedBox(width: 4),
                              Text(
                                widget.rating,
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Vị ngon tuyệt vời",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 20),
                    if (!widget.isCoffee) ...[
                      SizedBox(height: 20),
                      Text(
                        "Size",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSizeButton('S', '25000'),
                          _buildSizeButton('M', '30000'),
                          _buildSizeButton('L', '35000'),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Extras: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildExtrasItem('Thạch', '5000'),
                      _buildExtrasItem('Chân châu trắng', '5000'),
                      _buildExtrasItem('Pudding', '7000'),
                    ],
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tổng tiền",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Text(
                  "${totalPrice}đ",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
            SizedBox(width: 20),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Tạo chuỗi mô tả extras
                  String extrasDescription = '';
                  if (!widget.isCoffee) {
                    List<String> selectedExtrasList = [];
                    selectedExtras.forEach((extra, isSelected) {
                      if (isSelected) {
                        selectedExtrasList.add(extra);
                      }
                    });
                    if (selectedExtrasList.isNotEmpty) {
                      extrasDescription = selectedExtrasList.join(', ');
                    }
                  }

                  // Tạo tên sản phẩm với size và extras
                  String fullName = widget.name;
                  if (!widget.isCoffee) {
                    fullName += ' (Size $selectedSize)';
                    if (extrasDescription.isNotEmpty) {
                      fullName += ' - $extrasDescription';
                    }
                  }

                  CartManager.addItem(
                    CartItem(
                      name: fullName,
                      price: totalPrice.toString(),
                      image: widget.image,
                      size: !widget.isCoffee ? selectedSize : null,
                      extras:
                          extrasDescription.isNotEmpty
                              ? extrasDescription
                              : null,
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã thêm ${widget.name} vào giỏ hàng'),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'XEM GIỎ HÀNG',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => CartScreen(
                                    userId: widget.userId,
                                    username: widget.username,
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "Thêm vào giỏ hàng",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeButton(String size, String price) {
    bool isSelected = selectedSize == size;
    return InkWell(
      onTap: () {
        setState(() {
          selectedSize = size;
        });
      },
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepOrange : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              size,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '${price}đ',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtrasItem(String name, String price) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                selectedExtras[name] = !(selectedExtras[name] ?? false);
              });
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      selectedExtras[name] ?? false
                          ? Colors.deepOrange
                          : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  selectedExtras[name] ?? false
                      ? Icon(Icons.check, size: 16, color: Colors.deepOrange)
                      : Icon(Icons.add, size: 16, color: Colors.deepOrange),
            ),
          ),
          SizedBox(width: 12),
          Text(
            name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Spacer(),
          Text(
            '+${price}đ',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
