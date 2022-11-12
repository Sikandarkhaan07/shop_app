import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.amount,
    @required this.id,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url =
        'https://first-demo-project-9ab48-default-rtdb.firebaseio.com/orders.json';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrder = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    try{
      extractedData.forEach((orderId, orderData) {
        loadedOrder.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'] as double,
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (pItem) => CartItem(
                id: pItem['id'],
                price: pItem['price'] as double,
                quantity: pItem['quantity'],
                title: pItem['title'],
              ),
            )
                .toList(),
          ),
        );
      });
    }catch(error){
      print(error);
    }


    _orders = loadedOrder.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url =
        'https://first-demo-project-9ab48-default-rtdb.firebaseio.com/orders.json';
    final timeStamp = DateTime.now();
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(
        {
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        },
      ),
    );
    _orders.insert(
      0,
      OrderItem(
        amount: total,
        id: json.decode(response.body)['name'],
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
