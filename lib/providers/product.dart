import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavoriteValue(bool newValue){
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = 'https://shop-app-467f5.firebaseio.com/products/$id.json';
    try{
      final response = await http.patch(url, body: json.encode({
        'isFavorite': isFavorite,
      }));
      if(response.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
      }
    } catch (error) {
      // Rolling back
      _setFavoriteValue(oldStatus);
    }
  }

}
