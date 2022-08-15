import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderDetail {
  final String id;
  final double amount;
  final List<CartItem> orderedProducts;
  final DateTime dateTime;

  OrderDetail({
    required this.id,
    required this.amount,
    required this.orderedProducts,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderDetail> _orders = [];

  List<OrderDetail> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> orderedProducts, double amount) async {
    var timestamp = DateTime.now();
    var url = Uri.https(
        'myshop-304f7-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/orders.json');
    final response = await http.post(
      url,
      body: json.encode({
        'amount': amount,
        'dateTime': timestamp.toIso8601String(),
        'products': orderedProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
        0,
        OrderDetail(
          id: json.decode(response.body)['name'],
          amount: amount,
          orderedProducts: orderedProducts,
          dateTime: timestamp,
        ));
    notifyListeners();
  }

  Future<void> fetchAndSetOrder() async {
    var url = Uri.https(
        'myshop-304f7-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/orders.json');
    final response = await http.get(url);
    final List<OrderDetail> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) return;
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderDetail(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(
          orderData['dateTime'],
        ),
        orderedProducts: (orderData['products'] as List<dynamic>)
            .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity'],
                ))
            .toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
