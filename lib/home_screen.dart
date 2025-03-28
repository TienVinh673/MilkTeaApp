import 'package:flutter/material.dart';
import 'package:teamilkapp/cart_screen.dart';
import 'package:teamilkapp/product_detail_screen.dart';
import 'package:teamilkapp/milk_tea_screen.dart';
import 'package:teamilkapp/coffee_screen.dart';
import 'package:teamilkapp/Views/order_history_screen.dart';
import 'package:teamilkapp/Views/profile_screen.dart';
import 'package:teamilkapp/SQLite/database_helper.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  final String username;

  const HomeScreen({super.key, required this.userId, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            'Bubble Tea',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          titleSpacing: 16,
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/anhnen.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chào mừng ${widget.username}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Khám phá thế giới trà sữa tuyệt vời',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategorySection(),
                    SizedBox(height: 24),
                    _buildPopularSection(context),
                    SizedBox(height: 24),
                    _buildRecommendedSection(context),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            switch (index) {
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => OrderHistoryScreen(userId: widget.userId),
                  ),
                );
                break;
              case 2:
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
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ProfileScreen(
                          userId: widget.userId,
                          username: widget.username,
                        ),
                  ),
                );
                break;
            }
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Đơn hàng',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Giỏ hàng',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Danh mục',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCategoryItem(
              icon: Icons.local_cafe,
              label: 'Cà phê',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CoffeeScreen(
                          userId: widget.userId,
                          username: widget.username,
                        ),
                  ),
                );
              },
            ),
            _buildCategoryItem(
              icon: Icons.emoji_food_beverage,
              label: 'Trà sữa',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MilkTeaScreen(
                          userId: widget.userId,
                          username: widget.username,
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: EdgeInsets.all(16),
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
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.deepOrange),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phổ biến',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Container(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildPopularItem(
                context,
                'Trà sữa dâu',
                '30000',
                'assets/dau.jpg',
                '4.5',
                false,
              ),
              _buildPopularItem(
                context,
                'Cà phê đen',
                '15000',
                'assets/capheden.jpg',
                '4.6',
                true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPopularItem(
    BuildContext context,
    String name,
    String price,
    String image,
    String rating,
    bool isCoffee,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ProductDetailScreen(
                  name: name,
                  price: price,
                  image: image,
                  rating: rating,
                  isCoffee: isCoffee,
                  userId: widget.userId,
                  username: widget.username,
                ),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: EdgeInsets.only(right: 16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(
                        rating,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${price}đ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Đề xuất cho bạn',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        _buildRecommendedItem(
          context,
          'Trà sữa matcha',
          '30000',
          'assets/matcha.jpg',
          '4.8',
          false,
        ),
        SizedBox(height: 16),
        _buildRecommendedItem(
          context,
          'Bạc xỉu',
          '25000',
          'assets/bacxiu.jpg',
          '4.7',
          true,
        ),
      ],
    );
  }

  Widget _buildRecommendedItem(
    BuildContext context,
    String name,
    String price,
    String image,
    String rating,
    bool isCoffee,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ProductDetailScreen(
                  name: name,
                  price: price,
                  image: image,
                  rating: rating,
                  isCoffee: isCoffee,
                  userId: widget.userId,
                  username: widget.username,
                ),
          ),
        );
      },
      child: Container(
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
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
              child: Image.asset(
                image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          rating,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${price}đ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
