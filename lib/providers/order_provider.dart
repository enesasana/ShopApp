import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopapp/models/http_exception.dart';
import 'package:shopapp/providers/cart_provider.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url = 'https://shop-app-467f5.firebaseio.com/orders.json';
    try {
      final List<OrderItem> loadedOrders = [];
      final response = await http.get(url);
      final fetchedData = json.decode(response.body) as Map<String, dynamic>;
      if(fetchedData == null) return; // If there is no order yet, terminate
      fetchedData.forEach((orderId, orderData) {
        loadedOrders.add(
            OrderItem(
              id: orderId,
              amount: orderData['amount'],
              products: (orderData['products'] as List<dynamic>).map((item) =>
                  CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  )).toList(),
              dateTime: DateTime.parse(orderData['dateTime']),
            ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
        print('sss');
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://shop-app-467f5.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    try {
      final response = await http.post(url, body: json.encode({
        'amount': total,
        'products': cartProducts.map((cp) =>
        {
          'id': cp.id,
          'title': cp.title,
          'quantity': cp.quantity,
          'price': cp.price
        }).toList(),
        'dateTime': timestamp.toIso8601String(),
      }));

      // yeni sipariş üstte olsun diye insert -> 0
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> cancelOrder(String orderId) async{
    // Optimistic Updating
    final url = 'https://shop-app-467f5.firebaseio.com/orders/$orderId.json';
    final existingOrderIndex = _orders.indexWhere((order) => order.id == orderId);
    var existingOrder = _orders[existingOrderIndex];
    _orders.removeAt(existingOrderIndex);
    notifyListeners();
    final response = await http.delete(url);
    if(response.statusCode >= 400) {
      _orders.insert(existingOrderIndex, existingOrder);
      throw HttpException('Could not delete order.');
    }
    existingOrder = null;
  }

}
