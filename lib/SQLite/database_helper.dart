import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

import '../JSON/users.dart';
import '../JSON/order.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  final databaseName = "auth.db";

  String users = '''
   CREATE TABLE users (
   usrId INTEGER PRIMARY KEY AUTOINCREMENT,
   usrName TEXT NOT NULL,
   email TEXT NOT NULL,
   usrPassword TEXT NOT NULL,
   phone TEXT DEFAULT '',
   address TEXT DEFAULT ''
   )
   ''';

  String orders = '''
   CREATE TABLE orders (
   orderId INTEGER PRIMARY KEY AUTOINCREMENT,
   userId INTEGER,
   orderDate TEXT,
   totalAmount INTEGER,
   status TEXT,
   FOREIGN KEY (userId) REFERENCES users (usrId)
   )
   ''';

  String orderItems = '''
   CREATE TABLE order_items (
   itemId INTEGER PRIMARY KEY AUTOINCREMENT,
   orderId INTEGER,
   productName TEXT,
   quantity INTEGER,
   price INTEGER,
   size TEXT,
   extras TEXT,
   FOREIGN KEY (orderId) REFERENCES orders (orderId)
   )
   ''';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    if (_database != null) {
      return _database!;
    }

    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, databaseName);

      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          // Tạo các bảng theo thứ tự
          await db.execute(users);
          print('Users table created');
          await db.execute(orders);
          print('Orders table created');
          await db.execute(orderItems);
          print('OrderItems table created');
        },
        onOpen: (db) {
          print('Database opened successfully');
        },
      );

      return _database!;
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  //Authentication
  Future<bool> authenticate(Users usr) async {
    final Database db = await database;
    try {
      var result = await db.rawQuery(
        "SELECT * FROM users WHERE usrName = ? AND usrPassword = ?",
        [usr.usrName, usr.usrPassword],
      );
      return result.isNotEmpty;
    } catch (e) {
      print('Error authenticating user: $e');
      return false;
    }
  }

  //Sign up
  Future<int> createUser(Users usr) async {
    final Database db = await database;
    try {
      // Kiểm tra xem username đã tồn tại chưa
      var existingUser = await db.query(
        'users',
        where: 'usrName = ?',
        whereArgs: [usr.usrName],
      );

      if (existingUser.isNotEmpty) {
        throw Exception('Tên đăng nhập đã tồn tại');
      }

      // Kiểm tra xem email đã tồn tại chưa
      existingUser = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [usr.email],
      );

      if (existingUser.isNotEmpty) {
        throw Exception('Email đã được sử dụng');
      }

      // Thêm người dùng mới
      final id = await db.insert('users', usr.toMap());
      print('User created successfully with id: $id');
      return id;
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  //Get current User details
  Future<Users?> getUser(String usrName) async {
    final Database db = await database;
    var res = await db.query(
      "users",
      where: "usrName = ?",
      whereArgs: [usrName],
    );
    return res.isNotEmpty ? Users.fromMap(res.first) : null;
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'usrId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<void> updateUser(
    int id,
    String name,
    String email,
    String phone,
    String address,
  ) async {
    final db = await database;
    try {
      await db.rawUpdate(
        'UPDATE users SET email = ?, phone = ?, address = ? WHERE usrId = ?',
        [email, phone, address, id],
      );
      print('User updated successfully');
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  Future<void> updatePassword(int userId, String newPassword) async {
    final db = await database;
    await db.update(
      'users',
      {'usrPassword': newPassword},
      where: 'usrId = ?',
      whereArgs: [userId],
    );
  }

  // Phương thức tạo đơn hàng mới
  Future<int> createOrder(Order order) async {
    final Database db = await database;
    // Bắt đầu transaction
    return await db.transaction((txn) async {
      // Thêm thông tin đơn hàng
      final orderId = await txn.insert('orders', {
        'userId': order.userId,
        'orderDate': order.orderDate,
        'totalAmount': order.totalAmount,
        'status': order.status,
      });

      // Thêm các mặt hàng trong đơn hàng
      for (var item in order.items) {
        await txn.insert('order_items', {
          'orderId': orderId,
          'productName': item.productName,
          'quantity': item.quantity,
          'price': item.price,
          'size': item.size,
          'extras': item.extras,
        });
      }

      return orderId;
    });
  }

  // Lấy danh sách đơn hàng của người dùng
  Future<List<Order>> getUserOrders(int userId) async {
    final Database db = await database;
    final List<Map<String, dynamic>> orderMaps = await db.query(
      'orders',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'orderDate DESC',
    );

    return Future.wait(
      orderMaps.map((orderMap) async {
        final List<Map<String, dynamic>> itemMaps = await db.query(
          'order_items',
          where: 'orderId = ?',
          whereArgs: [orderMap['orderId']],
        );

        final items = itemMaps.map((item) => OrderItem.fromMap(item)).toList();

        return Order.fromMap(orderMap, items);
      }),
    );
  }

  // Cập nhật trạng thái đơn hàng
  Future<int> updateOrderStatus(int orderId, String status) async {
    final Database db = await database;
    return await db.update(
      'orders',
      {'status': status},
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
  }

  // Phương thức để xóa database
  Future<void> deleteDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    // Kiểm tra xem file database có tồn tại không
    if (await File(path).exists()) {
      await File(path).delete();
      print('Database deleted');
    }
    _database = null;
  }
}
