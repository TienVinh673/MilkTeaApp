import 'package:flutter/material.dart';
import 'package:teamilkapp/product_detail_screen.dart';

class CoffeeScreen extends StatelessWidget {
  final int userId;
  final String username;

  const CoffeeScreen({super.key, required this.userId, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cà Phê', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Các loại cà phê",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildProductItem(
                      context,
                      'Cà phê đen',
                      '15000',
                      'assets/capheden.jpg',
                      '4.5',
                    ),
                    SizedBox(height: 16),
                    _buildProductItem(
                      context,
                      'Cà phê sữa',
                      '20000',
                      'assets/caphesua.jpg',
                      '4.6',
                    ),
                    SizedBox(height: 16),
                    _buildProductItem(
                      context,
                      'Bạc xỉu',
                      '23000',
                      'assets/bacxiu.jpg',
                      '4.7',
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(
    BuildContext context,
    String name,
    String price,
    String imageUrl,
    String rating,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ProductDetailScreen(
                    name: name,
                    price: price,
                    image: imageUrl,
                    rating: rating,
                    isCoffee: true,
                    userId: userId,
                    username: username,
                  ),
            ),
          );
        },
        child: Container(
          height: 120,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(15),
                ),
                child: Image.asset(
                  imageUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          Text(
                            rating,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${price}đ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
