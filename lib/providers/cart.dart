import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum SelectedSize{
  smallSize,
  mediumSize,
  largeSize,
}


class CartItem {
  final String id;
  final String title;
  late final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  late Map<String, CartItem> _cartItem = {};

  Map<String, CartItem> get cartItem {
    return {..._cartItem};
  }


  int get itemCount {
    return _cartItem.length;
  }

  double get totalAmount {
    var total = 0.0;
    _cartItem.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addCartItem(String productId, String title, double price) {
    if (_cartItem.containsKey(productId)) {
      //if already exists
      _cartItem.update(
        productId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity + 1),
      );
    } else {
      _cartItem.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _cartItem.remove(productId);
    notifyListeners();
  }

  void addRemoveItem(String id, String operator) {
    if (_cartItem.containsKey(id)) {
      _cartItem.update(
        id,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          quantity: operator == '+'
              ? existingItem.quantity + 1
              : existingItem.quantity > 1 ? existingItem.quantity - 1 : existingItem.quantity,
        ),
      );
      notifyListeners();
    }
  }
  void clear(){
    _cartItem = {};
    notifyListeners();
  }
}
