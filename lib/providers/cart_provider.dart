import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCountInCart {
    return _items.length;
  }

  double get totalAmountOfCart {
    var total = 0.0;
    _items.forEach((key, carItem) =>
    {
      total += carItem.price * carItem.quantity
    });
    return total;
  }

  void addItemToCart(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      // productId'ye göre varsa önceki CartItem'i buluyor
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  // Buraya parametre olarak gelen 'id' Dismissible widget'inde 'key'e
  // atadığımız id oluyor
  void removeItemFromCart(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleIem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId].quantity > 1) {
      _items.update(productId, (existingCartItem) =>
          CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            quantity: existingCartItem.quantity - 1,
            price: existingCartItem.price,
          ));
    }
    else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCartAfterOrder() {
    _items = {};
    notifyListeners();
  }

}
