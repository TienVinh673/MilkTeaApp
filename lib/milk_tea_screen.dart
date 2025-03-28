import 'package:flutter/material.dart';
import 'package:teamilkapp/product_detail_screen.dart';

class MilkTeaScreen extends StatelessWidget {
  final int userId;
  final String username;

  const MilkTeaScreen({
    super.key,
    required this.userId,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trà Sữa', style: TextStyle(color: Colors.black)),
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
              "Các loại trà sữa",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildProductItem(
                  context,
                  'Trà sữa dâu',
                  '30000',
                  'assets/dau.jpg',
                  '4.5',
                  '2-4 phút',
                ),
                SizedBox(height: 16),
                _buildProductItem(
                  context,
                  'Trà sữa matcha',
                  '30000',
                  'assets/matcha.jpg',
                  '4.6',
                  '2-4 phút',
                ),
                SizedBox(height: 16),
                _buildProductItem(
                  context,
                  'Trà sữa socola',
                  '30000',
                  'assets/socola.jpg',
                  '4.8',
                  '2-4 phút',
                ),
                SizedBox(height: 16),
                _buildProductItem(
                  context,
                  'Trà sữa việt quất',
                  '30000',
                  'assets/tim.jpg',
                  '4.8',
                  '2-4 phút',
                ),
                SizedBox(height: 16),
                _buildProductItem(
                  context,
                  'Trà sữa chân châu',
                  '30000',
                  'assets/chan-chau.jpg',
                  '4.8',
                  '2-4 phút',
                ),
              ],
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
    String deliveryTime,
  ) {
    return InkWell(
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
                  isCoffee: false,
                  userId: userId,
                  username: username,
                ),
          ),
        );
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(15)),
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
    );
  }
}
